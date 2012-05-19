require 'active_support/concern'
require 'xommelier/core_ext/hash'
require 'xommelier/xml/schema'
require 'xommelier/xml/schema/complex_type'
require 'xommelier/xml/schema/complex_type/structure'

module Xommelier
  module Xml
    class Schema
      module Elements
        def self.included(mod)
          mod.send(:include, ComplexType::Structure)
          super
        end

        def self.extend_object(obj)
          obj.extend(ComplexType::Structure)
          super
        end

        DEFAULTS = {
          min:      1,    # minOccurs="1"
          max:      1,    # maxOccurs="1"
          fixed:    nil,  # no fixed value
          default:  nil,  # no default value
          node_type: :element
        }

        # Define new field or update options for previously defined one
        # @param name [Symbol] name of the element. defines accessors in derived class
        # @param options [Hash] options of defined field
        # @return [Field] defined field
        # @macro [attach] element
        #   @return [Field] the $1 element
        def element(name, options=nil)
          if options.is_a?(Hash)
            options = DEFAULTS.merge(options)
            element = field(name, options)
          end
          element || field(name)
        end

        def any(*args, &block)
          puts "#{is_a?(Class) ? name : inspect}.any(#{args.map(&:inspect).join(', ')})"
        end

        def elements
          fields.inject({}) do |result, (name, field)|
            result[name] = field if field.node_type == :element
            result
          end
        end
      end

      include Elements

      def element(name, options={}, &block)
        super(name, options, &block).tap do |element|
          types[name] = element
        end
      end
    end
  end
end
