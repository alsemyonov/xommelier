require 'xommelier/xml/schema/complex_type'
require 'xommelier/xml/schema/complex_type/field'
require 'active_model/attribute_methods'
require 'active_model/dirty'

module Xommelier
  module Xml
    class Schema
      module ComplexType
        # Provides accessors for elements, attributes and content (see {generated_attribute_methods})
        module Structure
          def fields
            @fields ||= {}.with_references
          end

          def field(name, options = nil)
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
                define_attribute_method(field.name) if is_a?(Class)
              elsif fields[name]
                field = fields[name]
              else
                field = fields.values.find { field.plural_method_name == name }
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
                    include ActiveModel::AttributeMethods
                    include ActiveModel::Dirty

                    delegate :fields, :field, to: 'self.class'
                    attribute_method_prefix 'reset_'
                    attribute_method_suffix '=', '?'
                    define_attribute_methods(fields.keys)
                    define_attribute_methods(fields.map { |n, f| f.plural_getter if f.plural? }.compact)
                  end
                  super
                end

                if is_a?(Module)
                  const_set(:FieldAccessors, generated_attribute_methods)
                  include self::FieldAccessors
                end

                generated_attribute_methods
              end
          end
        end
      end
    end
  end
end
