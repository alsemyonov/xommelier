require 'xommelier/xml/element'
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
          attr_writer :element_name

          self.elements = {}
          self.attributes = {}

          class << self
            include SingletonClassMethods
          end

          delegate :xmlns, to: 'self.class'
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
            child.elements    = elements.dup
            child.attributes  = attributes.dup
            include Xml::CommonAttributes
          end

          # Defines containing element
          # @example
          #   element :author, type: Xommelier::Atom::Person
          def element(name, options = {})
            options[:element_name] = options.delete(:as) { name }
            options[:ns] ||= if options[:type].try(:<, Xml::Element)
                               options[:ns] = options[:type].xmlns
                             else
                               xmlns
                             end
            elements[name] = DEFAULT_ELEMENT_OPTIONS.merge(options)
            define_element_accessors(name)
          end

          # Defines containing attribute
          def attribute(name, options = {})
            options[:ns] ||= xmlns
            attributes[name] = DEFAULT_OPTIONS.merge(options)
            define_attribute_accessors(name)
          end

          # Defines containing text
          def text(options = {})
            define_text_accessors
          end

          def any(&block)
            with_options(count: :any)  { |any| any.instance_eval(&block) }
          end

          def many(&block)
            with_options(count: :many) { |many| many.instance_eval(&block) }
          end

          def may(&block)
            with_options(count: :may) { |may| may.instance_eval(&block) }
          end

          def root; end

          private

          def define_element_accessors(name)
            element_options = elements[name]
            case element_options[:count]
            when :one, :may
              name = name.to_sym
              define_method(name) do |*args|
                if args[0]
                  write_element(name, args[0])
                end
                read_element(name)
              end
              alias_method "#{name}=", name
            when :many, :any
              plural = name.to_s.pluralize.to_sym
              element_options[:plural] = plural

              define_method(plural) do |*args|
                if args.any?
                  @elements[name] = args.flatten
                end
                @elements[name] ||= []
              end
              alias_method "#{plural}=", plural

              unless plural == name
                define_method(name) do |*args|
                  if args[0]
                    send(plural, [args[0]])
                  else
                    send(plural)[0]
                  end
                end
                alias_method "#{name}=", name
              end
            end
          end

          def define_attribute_accessors(name)
            define_method(name) do |*args|
              if args[0]
                write_attribute(name.to_s, args[0])
              end
              read_attribute(name)
            end
            alias_method "#{name}=", name
          end

          def define_text_accessors
            define_method(:text) do |*args|
              if args[0]
                write_text(args[0])
              end
              read_text
            end
            alias_method :text=, :text
          end
        end

        protected

        def element_name(value = nil)
          if value
            @element_name = value
          end
          @element_name ||= self.class.element_name
        end

        def element_options(name)
          self.class.elements[name.to_sym]
        end

        def read_element(name)
          @elements[name.to_sym]
        end

        def write_element(name, value)
          type = element_options(name)[:type]
          unless value.is_a?(type)
            value = if (type < Xommelier::Xml::Element) && !value.is_a?(Nokogiri::XML::Node)
                      type.new(value)
                    else
                      type.from_xommelier(value)
                    end
          end
          @elements[name.to_sym] = value
        end

        def remove_element(name)
          @elements.delete(name.to_sym)
        end

        def attribute_options(name)
          self.class.attributes[name.to_sym]
        end

        def read_attribute(name)
          @attributes[name.to_sym]
        end

        def write_attribute(name, value)
          type = attribute_options(name)[:type]
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
