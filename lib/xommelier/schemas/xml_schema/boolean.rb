# coding: utf-8
require 'xommelier/schemas/xml_schema'

module Xommelier
  module Schemas
    module XmlSchema
      # {Boolean} has the ·value space· required to support the mathematical concept of binary-valued logic: `true`, `false`
      #
      # An instance of a datatype that is defined as ·boolean· can have the following legal literals: true, false, 1, 0.
      #
      # The canonical representation for boolean is the set of literals `true`, `false`.
      #
      # @see http://www.w3.org/TR/xmlschema-2/#boolean xs:boolean
      class Boolean < AnySimpleType
        type_name :boolean

        BOOLEAN_MAP = {
          true => true, 'true' => true, '1' => true, 1 => true,
          false => false, 'false' => false, '0' => false, 0 => false,
        }

        facets :pattern, :white_space
        properties(
          ordered: false,
          bounded: false,
          cardinality: %w(finite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        # @param [String, Numeric, true, false]
        # @return [true, false]
        def self.deserialize(value)
          BOOLEAN_MAP.fetch(value) {
            raise DeserializationError.new(self, value)
          }
        end
      end
    end
  end
end
