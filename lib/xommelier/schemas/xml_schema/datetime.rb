# coding: utf-8
require 'xommelier/schemas/xml_schema'

module Xommelier
  module Schemas
    module XmlSchema
      # @see http://www.w3.org/TR/xmlschema-2/#dateTime xs:dateTime
      class DateTime < AnySimpleType
        type_name :dateTime

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :partial,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        def self.deserialize(value)
          case value
          when ::DateTime, ::Date, ::Time
            value.to_datetime
          when ::String
            begin
              ::DateTime.xmlschema(value)
            rescue ArgumentError
              nil
            end
          else
            super
          end
        end

        def serialize
          value.try(:to_time).try(:utc).try(:xmlschema)
        end
      end

      # @see http://www.w3.org/TR/xmlschema-2/#date xs:date
      class Date < AnySimpleType
        type_name :date

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :partial,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        def self.deserialize(value)
          case value
          when ::DateTime, ::Date, ::Time
            value.to_date
          when ::String
            begin
              ::Date.xmlschema(value)
            rescue ArgumentError
              nil
            end
          else
            super
          end
        end

        def serialize
          value.try(:xmlschema)
        end
      end

      # @see http://www.w3.org/TR/xmlschema-2/#time xs:time
      class Time < AnySimpleType
        type_name :time

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :partial,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        def self.deserialize(value)
          case value
          when ::Date # Date#to_time cases changin of Time Zone
            value.to_datetime.to_time
          when ::DateTime, ::Time
            value.to_time
          when ::String
            begin
              ::Time.xmlschema(value)
            rescue ArgumentError
              nil
            end
          else
            super
          end
        end

        def serialize
          value.try(:utc).try(:xmlschema)
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#gYear}
      class GYear < AnySimpleType
        type_name :gYear

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :partial,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        def self.deserialize(value)
          case value
          when /^\d+$/
            string.to_i
          else
            super
          end
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#gYearMonth}
      class GYearMonth < AnySimpleType
        type_name :gYearMonth

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :partial,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        def self.deserialize(value)
          case value
          when /^\d+-\d+$/
            value.split('-').map(&:to_i)
          else
            super
          end
        end

        def serialize
          value.join('-')
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#gMonth}
      class GMonth < AnySimpleType
        type_name :gMonth

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :partial,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        def self.deserialize(value)
          case value
          when /^--\d+$/
            value[2..-1].to_i
          else
            super
          end
        end

        def serialize
          "--#{value}"
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#gMonthDay}
      class GMonthDay < AnySimpleType
        type_name :gMonthDay

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :partial,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        def self.deserialize(value)
          case value
          when /^--\d+-\d+$/
            value[2..-1].split('-').map(&:to_i)
          else
            super
          end
        end

        def serialize
          "--#{value.join('-')}"
        end
      end

      # {http://www.w3.org/TR/xmlschema-2/#gDay}
      class GDay < AnySimpleType
        type_name :gDay

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :partial,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        def self.deserialize(value)
          case value
          when /^---\d+$/
            value[3..-1].to_i
          else
            super
          end
        end

        def serialize
          "---#{value}"
        end
      end
    end
  end
end
