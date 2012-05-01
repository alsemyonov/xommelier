require 'xommelier/xml/schema/field'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/module/delegation'
require 'active_model/attribute_methods'
require 'active_model/dirty'

module Xommelier
  module Xml
    class Schema
      # Provides accessors for elements, attributes and content (see {.field_accessors})
      module Fields
        def fields
          @fields ||= {}.with_references
        end

        def field(name, options = nil)
          #puts "#{respond_to?(:name) ? self.name : self}.field(#{name.inspect}, #{options.inspect})"
          if name.is_a?(Field)
            field = name
          else
            name = name.to_sym
            if options
              if options[:type].is_a?(Symbol)
                options[:type] = schema.find_or_create_type(options[:type])
              end
              options[:xmlns] = namespace
              fields[name] = field = Field.new(name, options)
              field_accessor(field)
              define_attribute_method(field.name) if is_a?(Class)
            else
              field = fields[name]
            end
          end
          field
        end

        protected

        def generated_attribute_methods
          @generated_attribute_methods ||=
            if is_a?(Module) && const_defined?(:FieldAccessors)
              self::FieldAccessors
            else
              generated_attribute_methods = Module.new
              def generated_attribute_methods.included(base)
                base.module_eval do
                  include Fields
                  include ActiveModel::AttributeMethods
                  #include ActiveModel::Dirty

                  delegate :fields, :field, to: 'self.class'
                  define_attribute_methods(fields.keys)
                end
                super
              end
              if is_a?(Module)
                const_set(:FieldAccessors, generated_attribute_methods)
                include self::FieldAccessors
                #include const_get(:FieldAccessors)
              end
              generated_attribute_methods
            end
        end

        def field_accessor(field)
          generated_attribute_methods.module_eval <<-END, __FILE__, __LINE__
            def #{field.getter}                       # def name
              read_attribute(#{field.getter.inspect})       #   read_field(:name)
            end                                       # end

            def #{field.setter}(value)                # def name=(value)
              ##{field.name}_will_change!              #   name_will_change!
              write_attributes(#{field.getter.inspect} => value)     #   write_field('name', value)
            end                                       # end

            def #{field.presence}                     # def name?
              #{field.getter}.present?                #   name.present?
            end                                       # end
          END
        end

        module Attributes
          def attributes
            fields.inject({}.with_indifferent_access) do |result, (name, field)|
              #result[name.to_s] = read_field(field)
              result[name.to_s] = field.get(xml_node)
              result
            end
          end

          def write_attributes(attributes)
            attributes.each do |name, value|
              field(name).set(xml_node, value)
            end
          end

          protected

          def read_attribute(name)
            field(name).get(xml_node)
          end

          def write_attribute(name, value)
            field(name).set(xml_node, value)
          end
        end
      end
    end
  end
end
