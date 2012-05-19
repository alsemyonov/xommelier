require 'xommelier/xml/schema'
require 'xommelier/xml/schema/type'
require 'xommelier/xml/schema/elements'
require 'xommelier/xml/schema/attributes'
require 'xommelier/xml/schema/sequence'
require 'xommelier/xml/schema/choice'
require 'xommelier/xml/schema/referenced'
require 'active_support/concern'
require 'active_support/core_ext/object/with_options'
require 'active_support/core_ext/module/delegation'
require 'xommelier/xml/schema/complex_type/serialization'

module Xommelier
  module Xml
    class Schema
      # Complex Type allow elements in it's content and may carry attributes
      module ComplexType
        extend ActiveSupport::Concern

        included do
          extend Structure
          include generated_attribute_methods
          include Serialization

          extend Attributes

          singleton_class.class_eval do
            extend Referenced
            referenced :attribute, :attribute_group
          end
        end

        delegate :mixed?, :content?, :abstract?, to: 'self.class'

        def to_hash
          attributes
        end

        module ClassMethods
          def mixed?
            !!options[:mixed]
          end

          def content?
            !mixed?
          end

          def abstract?
            !!options[:abstract]
          end

          def simple_content?
            options[:_content] == :simple
          end

          def complex_content?
            options[:_content] == :complex
          end

          def deserialize(value)
            if content?
              base.deserialize(value)
            else
              value
            end
          end

          def simple_content(options={}, &block)
            raise ComplexContentTypeError.new(self, :complex) if self.options[:_content] == :complex
            self.options = options.merge(_content: :simple)
            require 'xommelier/xml/schema/complex_type/simple_content'
            send(:include, SimpleContent)
            module_eval(&block) if block_given?
          end

          def complex_content(options={}, &block)
            raise ComplexContentTypeError.new(self, :simple) if self.options[:_content] == :simple
            self.options = options.merge(_content: :complex)
            require 'xommelier/xml/schema/complex_type/complex_content'
            send(:include, ComplexContent)
            module_eval(&block) if block_given?
          end

          protected

          def method_missing(method_name, *args, &block)
            case method_name
            when :sequence, :choice, :element
              complex_content
              __send__(method_name, *args, &block)
            else
              super
            end
          end

          def respond_to_missing?(method_name, include_private=false)
            case method_name
            when :sequence, :choice, :element
              options[:_content] == :complex
            end
            super
          end

          def define_accessors?
            true
          end
        end
      end
    end
  end
end
