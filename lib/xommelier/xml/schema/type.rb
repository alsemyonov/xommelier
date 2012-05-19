require 'xommelier/xml/schema'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/module/delegation'
require 'active_model/naming'

module Xommelier
  module Xml
    class Schema
      # @abstract Subclass should use method {Type.simple_type} or {Type.complex_type} to implement real class
      class Type < Delegator
        extend ActiveModel::Naming

        class_attribute :node_type, :options

        class << self
          include Utils::Naming

          attr_reader :base

          def inherited(child)
            child.options = options.dup
            child.type_name if child.name
          end

          def schema
            @schema ||= containing_module.schema
          end

          def schema=(schema)
            @schema = schema
          end

          delegate :ns, :namespace, :xmlns, to: :schema, allow_nil: true

          def type_name(name=self.local_constant_name)
            if old_name = schema.types.key(self)
              schema.types.delete(old_name)
            end
            schema.types[name.to_sym] = self
          end

          def type_name(name=nil)
            if name
              old_name = schema.types.key(self)
              schema.types.delete(old_name) if old_name
              @type_name = name.to_sym
            end
            unless schema.types.key(self)
              @type_name ||= local_constant_name.to_sym
              schema.types[@type_name] = self
            end
            @type_name ||= schema.types.key(self)
          end

          def options(options={})
            @options ||= {}
            if options
              complex_type(options.delete(:complex_type)) if options[:complex_type]
              simple_type(options.delete(:simple_type))   if options[:simple_type]
              @base = options.delete(:base)               if options[:base]
              @options.merge!(options)
            end
            @options
          end
          alias options= options

          def simple?
            options[:_type] == :simple
          end

          def complex?
            options[:_type] == :complex
          end

          # Declare class as complex
          # @scope class
          # @see ComplexType
          def complex_type(options={}, &block)
            raise ContentTypeError.new(self, :complex) if self.options[:_type] == :simple
            if options[:_type] == :simple
              raise "Type #{name} already defined as simple, it cannot be complex also"
            end
            require 'xommelier/xml/schema/complex_type'
            send(:include, ComplexType)
            self.options = self.options.merge(options).merge(_type: :complex)
            class_eval(&block) if block_given?
          end

          # Declare class as simple
          # @scope class
          # @see SimpleType
          def simple_type(options={}, &block)
            raise ContentTypeError.new(self, :simple) if self.options[:_type] == :complex
            require 'xommelier/xml/schema/simple_type'
            send(:include, SimpleType)
            self.options = self.options.merge(options).merge(_type: :simple)
            class_eval(&block) if block_given?
          end

          # TODO remove method_missing after all needed methods would be implemented
          #def method_missing(method, *args, &block)
            #$stderr.puts "#{name}##{method}(#{args.map(&:inspect).join(', ')})"
          #end
        end

        def initialize(value = nil)
          self.value = value if value.present? || value == false
        end

        def __getobj__
          @value
        end

        def __setobj__(value)
          self.value = value
        end

        #def __setobj__(obj)
          #self.xml_node = obj
        #end

        attr_reader :value

        delegate :namespace, to: 'self.class'

        def value=(string)
          @value = deserialize(restrict_value_of(string))
        end

        # @return [String] restricted and serialized value applicable to XML document
        def serialize
          restrict_value_of(value.to_s)
        end

        def to_xml
          serialize
        end

        protected

        delegate :deserialize, to: 'self.class'
      end
    end
  end
end

require 'xommelier/xml/schema/type/restriction'
