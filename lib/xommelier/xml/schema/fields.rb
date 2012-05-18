require 'xommelier/xml/schema/field'
require 'xommelier/xml/proxy'
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
                  include ActiveModel::Dirty

                  delegate :fields, :field, to: 'self.class'
                  attribute_method_prefix 'reset_'
                  attribute_method_suffix '=', '?'
                  define_attribute_methods(fields.keys)
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

        module Attributes
          attr_reader :attributes

          def initialize(*args)
            super(*args)
            @attributes = Xml::Proxy.new(xml_node, self.class)
          end

          protected

          def attributes=(attrs)
            @attributes.replace(attrs)
          end

          def write_attributes(attributes)
            @attributes.merge!(attributes)
          end

          def read_attribute(name)
            @attributes[name]
          end
          alias attribute read_attribute

          def write_attribute(name, value)
            @attributes[name] = value
          end
          alias attribute= write_attribute

          def attribute?(name)
            @attributes[name].present?
          end

          def reset_attribute(name)
            @attributes.reset(name)
          end
        end
      end
    end
  end
end
