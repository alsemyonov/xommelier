require 'xommelier/xml/schema'
require 'active_support/concern'

module Xommelier
  module Xml
    class Schema
      module SimpleType
        extend ActiveSupport::Concern

        protected

        module ClassMethods
          # Deserializes value from string
          # @param [String] value from XML
          # @return Ruby native type
          def deserialize(value)
            value
          end

          # Define facets used in this simple type
          # @param facets [Array<Symbol>] facets used in this simple type
          def facets(*facets)
            @facets = facets
          end

          # Define properties used in this simple type
          # @param properties [Hash] name of properies mapped to its values
          def properties(properties={})
            @properties = properties
          end

          def list(klass)
            restriction { list klass }

            singleton_class.class_eval do
              redefine_method(:deserialize) do |string|
                string.split(' ').map { |part| klass.new(part) }
              end
              public(:deserialize)
            end

            define_method(:serialize) do
              value.map { |part| part.serialize }.join(' ')
            end
          end
        end
      end
    end
  end
end
