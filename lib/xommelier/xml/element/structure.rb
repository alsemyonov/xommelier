require 'xommelier/xml/element'
require 'xommelier/xml/element/structure/property'
require 'active_support/concern'
require 'active_support/core_ext/module/delegation'
require 'active_support/core_ext/object/with_options'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/string/inflections'
require 'active_support/inflections'

module Xommelier
  module Xml
    class Element
      module Structure
        extend ActiveSupport::Concern

        included do
          class_attribute :elements, :attributes

          self.elements   = {}
          self.attributes = {}

          attr_writer :element_name

          extend SingletonClassMethods

          delegate :xmlns, :schema, to: 'self.class'
        end

        module SingletonClassMethods
          def containing_module
            @containing_module ||= ("::#{name.gsub(/::[^:]+$/, '')}").constantize
          end

          def xmlns(value = nil)
            if value
              @xmlns = case value
                       when Module
                         value.xmlns
                       else
                         value
                       end
            end
            @xmlns ||= find_namespace
          end

          alias_method :xmlns=, :xmlns

          def schema
            containing_module.schema
          end

          def element_name(element_name = nil)
            @element_name = element_name if element_name
            @element_name ||= find_element_name
          end

          private

          def find_namespace
            if self == containing_module
              Xommelier::Xml::DEFAULT_NS
            else
              containing_module.xmlns
            end
          end

          def find_element_name
            name.demodulize.underscore.dasherize
          end
        end

        module ClassMethods
          def inherited(child)
            child.elements   = elements.dup
            child.attributes = attributes.dup
          end

          # Defines containing element
          # @example
          #   element :author, type: Xommelier::Atom::Person
          def element(name, options = {})
            options[:ns]   ||= if options[:type].try(:<, Xml::Element)
                                 options[:type].xmlns
                               else
                                 xmlns
                               end
            element = Element.new(name, options)
            elements[name] = element
            define_element_accessors(element)
          end

          # Defines containing attribute
          def attribute(name, options = {})
            options[:ns]     ||= xmlns
            attributes[name] = Attribute.new(name, options)
            define_attribute_accessors(name)
          end

          # Defines containing text
          def text(*)
            define_text_accessors
          end

          def any(&block)
            with_options(count: :any) { |any| any.instance_eval(&block) }
          end

          def many(&block)
            with_options(count: :many) { |many| many.instance_eval(&block) }
          end

          def may(&block)
            with_options(count: :may) { |may| may.instance_eval(&block) }
          end

          private

          def define_element_accessors(element)
            name = element.name
            if element.multiple?
              # Define plural accessors
              plural = element.plural

              rw_accessor(plural) do |*args|
                args.flatten.each_with_index do |object, index|
                  write_element(name, object, index)
                end if args.length > 0

                @elements[name] ||= []
              end

              # Define singular accessors for first element
              unless element.numbers_equal?
                rw_accessor(name) do |*args|
                  send(plural, [args[0]]) if args.length == 1
                  send(plural)[0]
                end
              end
            else
              # Define singular accessors
              rw_accessor(name) do |*args|
                write_element(name, args[0]) if args.length == 1
                read_element(name)
              end
            end
          end

          def define_attribute_accessors(name)
            rw_accessor(name) do |*args|
              write_attribute(name, args[0]) if args.length == 1
              read_attribute(name)
            end
          end

          def define_text_accessors
            rw_accessor(:text) do |*args|
              write_text(args[0]) if args.length == 1
              read_text
            end
            alias_attribute :content, :text
          end

          protected

          # Defines read-write accessor for +name+ and provides alias for write-only version
          def rw_accessor(name, &block)
            define_method(name, &block)
            alias_method "#{name}=", name
          end
        end

        protected

        def set_default_values
          self.class.attributes.merge(self.class.elements).each do |name, property|
            send("#{name}=", property.default) if property.default?
          end
        end

        def options=(options = {})
          if options.key?(:element_name)
            element_name(options.delete(:element_name))
          end
        end

        def element_name(value = nil)
          @element_name = value if value
          @element_name ||= self.class.element_name
        end

        # @return [Xommelier::Xml::Element::Structure::Element]
        def element_options(name)
          self.class.elements[name.to_sym]
        end

        def read_element(name, index = nil)
          index ? @elements[name.to_sym][index] : @elements[name.to_sym]
        end

        def write_element(name, value, index = nil)
          element = element_options(name)
          type = element.type
          unless value.is_a?(type)
            value = if element.complex_type? && !value.is_a?(Nokogiri::XML::Node)
                      type.new(value)
                    else
                      type.from_xommelier(value)
                    end
          end
          if index
            @elements[element.name]        ||= []
            @elements[element.name][index] = value
          else
            @elements[element.name] = value
          end
        end

        def remove_element(name)
          @elements.delete(name.to_sym)
        end

        # @return [Xommelier::Xml::Element::Structure::Attribute]
        def attribute_options(name)
          self.class.attributes[name.to_sym]
        end

        def read_attribute(name)
          @attributes[name.to_sym]
        end

        def write_attribute(name, value)
          type = attribute_options(name).type
          value = type.from_xommelier(value) unless value.is_a?(type)
          @attributes[name.to_sym] = value
        end

        def remove_attribute(name)
          @attributes.delete(name.to_sym)
        end

        def text?
          respond_to?(:text)
        end

        def read_text
          @text
        end

        def write_text(text)
          @text = text
        end

        def remove_text
          @text = nil
        end
      end
    end
  end
end
