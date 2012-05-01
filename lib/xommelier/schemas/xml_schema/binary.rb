# coding: utf-8
require 'xommelier/schemas/xml_schema'

module Xommelier
  module Schemas
    module XmlSchema

      # @see http://www.w3.org/TR/xmlschema-2/#base64Binary xs:base64Binary
      class Base64Binary < AnySimpleType
        type_name :base64Binary

        facets :length, :min_length, :max_length, :pattern, :enumeration, :white_space
        properties(
          ordered: false,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction do
          white_space :collapse, fixed: true
        end
      end

      # @see http://www.w3.org/TR/xmlschema-2/#hexBinary xs:hexBinary
      class HexBinary < AnySimpleType
        type_name :hexBinary

        facets :length, :min_length, :max_length, :pattern, :enumeration, :white_space
        properties(
          ordered: false,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction do
          white_space :collapse, fixed: true
        end
      end
    end
  end
end
