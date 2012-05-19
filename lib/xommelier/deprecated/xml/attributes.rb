require 'xommelier/xml'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/with_options'
require 'active_support/core_ext/module/delegation'
require 'active_model/attribute_methods'
require 'active_model/dirty'

module Xommelier
  module Xml
    require 'xommelier/xml/schema/field'
    # @deprecated
    Field = Schema::Field

    # @deprecated
    module Attributes
      extend ActiveSupport::Concern

      included do
        include ActiveModel::AttributeMethods
        include ActiveModel::Dirty

        delegate :[], :[]=, :read_attribute, :write_attribute, to: :attributes

        class_attribute :fields, :defaults, :lookup_undefined_fields
        self.defaults = {}
        self.fields = ActiveSupport::HashWithIndifferentAccess.new
        self.lookup_undefined_fields = true
      end

      def attributes
        @attributes ||= AttributesProxy.new(self)
      end

      def attributes=(attributes)
        attributes.merge!(attributes)
      end

      def initialize(contents = nil, options = {})
        self.contents = defaults
        super(contents)
      end

      module ClassMethods
        def inherited(child)
          super
          child.defaults = defaults.dup
          child.fields = fields.dup
          child.lookup_undefined_fields = lookup_undefined_fields
        end

        def field_names
          fields.keys
        end

        def field(name, options = {})
          Field.new(name, options).tap do |field|
            fields[name] = field
            defaults[name] = field.default if field.default.present?
            if field.plural?
              field_plural_accessor(field)
            else
              field_accessor(field)
            end
          end
        end

        def element(name, options = {})
          field(name, options.merge(node_type: :element))
        end

        def attribute(name, options = {})
          field(name, options.merge(node_type: :attribute))
        end

        def text(name = :text, options = {})
          options[:type] ||= String
          field(name, options.merge(node_type: :text))
        end

        def any(&block)
          with_options(min: 0, max: :unbounded)  { |any|  any.instance_eval(&block)   }
        end

        def many(&block)
          with_options(min: 1, max: :unbounded) { |many| many.instance_eval(&block)  }
        end

        def may(&block)
          with_options(min: 0, max: 1)  { |may|  may.instance_eval(&block)   }
        end

        protected

        def field_plural_accessor(field)
          define_attribute_method(field.plural_method_name)
          class_eval <<-STR, __FILE__, __LINE__
            def #{field.plural_getter}
              []
            end

            def #{field.plural_setter}(value)
              value
            end

            def #{field.plural_presence}
              false
            end
          STR
          field_accessor(field) unless field.method_name == field.plural_method_name
        end

        def field_accessor(field)
          define_attribute_method(field.method_name)
          class_eval <<-STR, __FILE__, __LINE__
            def #{field.getter}                                              # def name
              #{field.type}.from_xommelier(read_attribute('#{field.name}'))  #   String.from_xommelier(read_attribute('name'))
            end                                                              # end

            def #{field.setter}(value)                # def name=(value)
              #{field.name}_will_change!              #   name_will_change!
              write_attribute('#{field.name}', value) #   write_attribute('name', value)
            end                                       # end

            def #{field.presence}                     # def name?
              #{field.getter}.present?                #   name.present?
            end                                       # end
          STR
        end
      end
    end
  end
end
