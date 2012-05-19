require 'active_support/concern'
require 'xommelier/xml/schema/complex_type'
require 'xommelier/xml/schema/referenced'

module Xommelier
  module Xml
    class Schema
      # Complex Type allow elements in it's content and may carry attributes
      module ComplexType
        module ComplexContent
          extend ActiveSupport::Concern

          included do
            extend Elements

            singleton_class.class_eval do
              extend Referenced
              referenced :element
            end
          end

          def __getobj__
            attributes
          end

          module ClassMethods
            def sequence(options = {}, &block)
              Sequence.new(options.merge(schema: schema), &block).tap do |sequence|
                fields << sequence
                if is_a?(Class)
                  define_attribute_methods(sequence.fields.keys)
                  include sequence.generated_attribute_methods
                end
              end
            end

            def choice(options = {}, &block)
              Choice.new(options.merge(schema: schema), &block).tap do |choice|
                fields << choice
                if is_a?(Class)
                  define_attribute_methods(choice.fields.keys)
                  include choice.generated_attribute_methods
                end
              end
            end
          end
        end
      end
    end
  end
end
