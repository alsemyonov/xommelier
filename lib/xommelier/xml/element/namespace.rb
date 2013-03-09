require 'xommelier/xml/element'
require 'active_support/concern'

module Xommelier
  module Xml
    class Element
      module Namespace
        extend ActiveSupport::Concern

        module ClassMethods
          # @return [Xommelier::Xml::Namespace] associated namespace
          def xmlns(value = nil)
            self.xmlns = value if value
            @xmlns ||= find_namespace
          end

          # @param [Module, Xommelier::Xml::Namespace] value namespace object or module
          def xmlns=(value)
            @xmlns = case value
                     when Module
                       value.xmlns
                     else
                       value
                     end
          end

          # @return [Nokogiri::XML::Schema] schema associated with element's namespace or module
          def schema
            containing_module.schema
          end

          # @return [String] path to schema file
          def schema_location
            containing_module.schema_location
          end

          protected

          # @return [Module, Class]
          def containing_module
            @containing_module ||= ("::#{name.gsub(/::[^:]+$/, '')}").constantize
          end

          # @return [Xommelier::Xml::Namespace]
          def find_namespace
            (self == containing_module ? Xommelier::Xml : containing_module).xmlns
          end
        end

        # @return [true, false]
        def valid?
          validate
          schema_validation_errors.empty?
        end

        # @return [Array<Nokogiri::XML::SyntaxError>]
        attr_reader :schema_validation_errors
        alias errors schema_validation_errors # compatibility

        protected

        # Validates document
        def validate
          @schema_validation_errors = []
          if self.class.schema
            #document = ensure_xml_document
            document = Nokogiri::XML(to_xml)
            self.class.schema.validate(document).each do |error|
              @schema_validation_errors << error
            end
            if @schema_validation_errors.any?
              puts self.class, self.class.schema_location, document
              require 'pp'
              pp @schema_validation_errors
            end
          else
            raise NoSchemaError.new(self)
          end
        end
      end
    end
  end
end
