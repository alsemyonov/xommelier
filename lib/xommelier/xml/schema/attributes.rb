require 'xommelier/core_ext/hash'
require 'xommelier/xml/schema'
require 'xommelier/xml/schema/complex_type'
require 'xommelier/xml/schema/complex_type/structure'

module Xommelier
  module Xml
    class Schema
      module Attributes
        def self.included(mod)
          mod.send(:include, ComplexType::Structure)
          super
        end

        def self.extend_object(obj)
          obj.extend(ComplexType::Structure)
          super
        end

        DEFAULTS = {
          required: false,  # use="optional"
          fixed:    nil,    # no fixed value
          default:  nil,    # no default value
          node_type: :attribute
        }

        def attributes
          fields.inject({}) do |result, (name, field)|
            result[name] = field if field.node_type == :attribute
            result
          end
        end

        # Define new attribute or update options for previously defined one
        # @param name [Symbol] name of the attribute. defines accessors in derived class
        # @param options [Hash] options of defined attribute
        # @return [Field] defined field
        # @macro [attach] attribute
        #   @return [Field] the $1 element
        def attribute(name, options={}, &block)
          if options.any?
            options = DEFAULTS.merge(options)
            attribute = field(name, options)
          end
          attribute || field(name)
        end

        def attribute_group(name, options={}, &block)
          name = name.to_sym
          group = schema.types[name] ||= AttributeGroup.new(name, options.merge(schema: schema))
          group.instance_eval(&block) if block_given?
          fields << group
          if is_a?(Module)
            define_attribute_methods(group.fields.keys)
            include group.generated_attribute_methods
          end
          group
        end

        def any_attribute(*args, &block)
          puts "#{name}.any_attribute(#{args.map(&:inspect).join(', ')})"
        end
      end

      include Attributes

      def attribute(name, options={}, &block)
        super(name, options, &block).tap do |attribute|
          types[name] = attribute
        end
      end

      def attribute_group(*args, &block)
        super(*args, &block).tap do |group|
          types[group.name] = group
        end
      end
    end
  end
end

require 'xommelier/xml/schema/attribute_group'
