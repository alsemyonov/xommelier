# coding: utf-8
require 'xommelier/schemas/xml_schema'

module Xommelier
  module Schemas
    module XmlSchema
      # {Decimal} represents a subset of the real numbers, which can be represented by decimal numerals.
      #
      # The ·value space· of decimal is the set of numbers that can be obtained by multiplying an integer by a non-positive power of ten, i.e., expressible as i × 10^-n where i and n are integers and n >= 0. Precision is not reflected in this value space; the number 2.0 is not distinct from the number 2.00. The ·order-relation· on decimal is the order relation on real numbers, restricted to this subset.
      #
      # {http://www.w3.org/TR/xmlschema-2/#decimal}
      class Decimal < AnySimpleType
        type_name :decimal

        facets :total_digits, :fraction_digits, :pattern, :white_space, :enumeration, :max_inclusive, :max_exclusive, :min_inclusive, :min_Exclusive
        properties(
          ordered: :total,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: true
        )
        restriction do
          white_space :collapse, fixed: true
        end

        # @return [Numeric, nil] decimal value
        def self.deserialize(value)
          return nil if value.blank?
          case value
          when ::String
            begin
              value =~ /\./ ? Float(value) : Integer(value)
            rescue ArgumentError => e
              value
            end
          when Numeric
            value
          else
            super
          end
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#integer}
      class Integer < Decimal
        type_name :integer

        restriction do
          fraction_digits 0, fixed: true
          pattern /[\-+]?[0-9]+/
        end

        # @return [Integer, nil] decimal value
        def self.deserialize(value)
          return nil if value.blank?
          case value
          when ::String
            begin
              Integer(value)
            rescue ArgumentError => e
              value
            end
          when Numeric
            value.to_i
          else
            super
          end
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#nonPositiveInteger}
      class NonPositiveInteger < Integer
        type_name :nonPositiveInteger

        restriction { max_inclusive 0 }
      end

      # {http://www.w3.org/TR/xmlschema-2/#negativeInteger}
      class NegativeInteger < NonPositiveInteger
        type_name :negativeInteger

        restriction { max_inclusive -1 }
      end

      # {http://www.w3.org/TR/xmlschema-2/#long}
      class Long < Integer
        type_name :long

        properties(
          bounded: true,
          cardinality: :finite
        )
        restriction do
          min_inclusive -9223372036854775808
          max_inclusive 9223372036854775807
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#int}
      class Int < Long
        type_name :int

        restriction do
          min_inclusive -2147483648
          max_inclusive 2147483647
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#short}
      class Short < Int
        type_name :short

        restriction do
          min_inclusive -32768
          max_inclusive 32767
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#byte}
      class Byte < Short
        type_name :byte

        restriction do
          min_inclusive -128
          max_inclusive 127
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#nonNegativeInteger}
      class NonNegativeInteger < Integer
        type_name :nonNegativeInteger

        restriction do
          min_inclusive 0
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#unsignedLong}
      class UnsignedLong < NonNegativeInteger
        type_name :unsignedLong

        properties(
          bounded: true,
          cardinality: :finite
        )
        restriction do
          max_inclusive 18446744073709551615
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#unsignedInt}
      class UnsignedInt < UnsignedLong
        type_name :unsignedInt

        restriction do
          max_inclusive 4294967295
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#unsignedShort}
      class UnsignedShort < UnsignedInt
        type_name :unsignedShort

        restriction do
          max_inclusive 65535
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#unsignedByte}
      class UnsignedByte < UnsignedShort
        type_name :unsignedByte

        restriction do
          max_inclusive 255
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#positiveInteger}
      class PositiveInteger < NonNegativeInteger
        type_name :positiveInteger

        restriction do
          min_inclusive 1
        end
      end

      # {Float} is patterned after the IEEE single-precision 32-bit floating point type [IEEE 754-1985].
      #
      # The basic ·value space· of float consists of the values m × 2^e, where m is an integer whose absolute value is less than 2^24, and e is an integer between -149 and 104, inclusive. In addition to the basic ·value space· described above, the ·value space· of float also contains the following three special values: positive and negative infinity and not-a-number (NaN). The ·order-relation· on float is: x < y iff y - x is positive for x and y in the value space. Positive infinity is greater than all other non-NaN values. NaN equals itself but is ·incomparable· with (neither greater than nor less than) any other value in the ·value space·.
      #
      # @see http://www.w3.org/TR/xmlschema-2/#float xs:float
      class Float < AnySimpleType
        Infinity = 1.0 / 0.0

        type_name :float

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :total,
          bounded: true,
          cardinality: :finite,
          numeric: true
        )
        restriction { white_space :collapse, fixed: true}

        def self.deserialize(value)
          return nil if value.blank?
          case value
          when 'INF'
            Infinity
          when Numeric
            value.to_f
          when ::String
            begin
              Float(value)
            rescue ArgumentError => e
              value
            end
          else
            super
          end
        end

        def serialize
          return 'INF' if value == Infinity
          super
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#double}
      class Double < AnySimpleType
        Infinity = 1.0 / 0.0

        type_name :double

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :total,
          bounded: true,
          cardinality: :finite,
          numeric: true
        )
        restriction { white_space :collapse, fixed: true}

        def self.deserialize(value)
          return nil if value.blank?
          case value
          when 'INF'
            Infinity
          when Numeric
            value.to_f
          when ::String
            begin
              Float(value)
            rescue ArgumentError => e
              value
            end
          else
            super
          end
        end

        def serialize
          return 'INF' if value == Infinity
          super
        end
      end
    end
  end
end
