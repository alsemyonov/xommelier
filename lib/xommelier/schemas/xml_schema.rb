# coding: utf-8
require 'xommelier/schemas'
require 'xommelier/xml/schema'
require 'xommelier/xml/schema/dsl'
require 'xommelier/xml/schema/type'

module Xommelier
  module Schemas
    module XmlSchema
      extend Xommelier::Xml::Schema::DSL

      schema :xs,
        xmlns: {
          xs: 'http://www.w3.org/2001/XMLSchema'
        }

      # @abstract Abstract type, ancestors of all types
      # @see Xml::Schema::Type
      AnyType = Xml::Schema::Type
      AnyType.schema = schema
      AnyType.type_name :anyType

      # @abstract Abstract simple type, ancestor of all simple types
      class AnySimpleType < AnyType
        type_name :anySimpleType

        simple_type
      end
    end
  end
end

require 'xommelier/schemas/xml_schema/boolean'
require 'xommelier/schemas/xml_schema/binary'
require 'xommelier/schemas/xml_schema/datetime'
require 'xommelier/schemas/xml_schema/duration'
require 'xommelier/schemas/xml_schema/numeric'
require 'xommelier/schemas/xml_schema/string'

__END__

module Xommelier
  module Schemas
    module XmlSchema
      # This type is extended by almost all schema types
      # to allow attributes from other namespaces to be
      # added to user schemas.
      class OpenAttrs < AnyType
        complex_type do
          any_attribute namespace: :other, process_contents: :lax
        end
      end


      # This type is extended by all types which allow annotation
      # other than <schema> itself
      class Annotated < OpenAttrs
        complex_type do
          complex_content base: ns.xs.openAttrs do
            sequence do
              element ref: :annotation, min: 0
            end
            attribute :id, type: ID
          end
        end
      end
    end
  end
end
