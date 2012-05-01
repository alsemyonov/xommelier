# coding: utf-8
require 'xommelier/schemas/xml_schema'
require 'active_support/duration'
require 'active_support/core_ext/numeric/time'
require 'active_support/core_ext/integer/time'
require 'active_support/core_ext/float/rounding'

module Xommelier
  module Schemas
    module XmlSchema
      # {Duration} represents a duration of time.
      #
      # The ·value space· of duration is a six-dimensional space where the coordinates designate the Gregorian year, month, day, hour, minute, and second components defined in § 5.5.3.2 of [ISO 8601], respectively. These components are ordered in their significance by their order of appearance i.e. as year, month, day, hour, minute, and second.
      #
      # @see http://www.w3.org/TR/xmlschema-2/#duration xs:duration
      class Duration < AnySimpleType
        type_name :duration

        DURATION_REGEXP = %r{
          ^
          (?<sign>\+|\-)?
          P(
            ((?<weeks>\d+)W)
            |
            (
              ((?<years>\d+)Y)?
              ((?<months>\d+)M)?
              ((?<days>\d+)D)?
              T?
              ((?<hours>\d+)H)?
              ((?<minutes>\d+)M)?
              ((?<seconds>\d+(\.\d+)?)S)?
            )
          )
          $
        }x

        facets :pattern, :enumeration, :white_space, :max_inclusive, :max_exclusive, :min_inclusive, :min_exclusive
        properties(
          ordered: :partial,
          bounded: false,
          cardinality: %w(countably infinite),
          numeric: false
        )
        restriction { white_space :collapse, fixed: true }

        class << self
          def parse_duration(duration)
            r = DURATION_REGEXP.match(duration)
            seconds = r[:years].to_i.years +
              r[:months].to_i.months +
              r[:days].to_i.days +
              r[:hours].to_i.hours +
              r[:minutes].to_i.minutes +
              r[:seconds].to_f.seconds +
              r[:weeks].to_i.weeks
            if r[:sign] == '-'
              seconds = -seconds
            end
            seconds
          rescue NoMethodError
            nil
          end

          def deserialize(value)
            case value
            when ::ActiveSupport::Duration
              value
            when ::Numeric
              value.seconds
            when ::String #DURATION_REGEXP
              raise DeserializationError.new(self, value) unless DURATION_REGEXP.match(value)
              parse_duration(value)
            else
              raise DeserializationError.new(self, value)
            end
          end
        end

        def serialize
          seconds = value
          ''.tap do |display|
            if seconds < 0
              display << '-'
              seconds = -seconds
            end

            display << 'P'

            weeks_count = seconds.div(1.week)
            if weeks_count > 0 && seconds == weeks_count.weeks
              display << "#{weeks_count}W"
            else
              years_count, seconds = seconds.divmod(1.year)
              display << "#{years_count}Y" if years_count > 0

              months_count, seconds = seconds.divmod(1.month)
              display << "#{months_count}M" if months_count > 0

              days_count, seconds = seconds.divmod(1.day)
              display << "#{days_count}D" if days_count > 0

              if seconds > 0
                display << 'T'

                hours_count, seconds = seconds.divmod(1.hour)
                display << "#{hours_count}H" if hours_count > 0

                minutes_count, seconds = seconds.divmod(1.minute)
                display << "#{minutes_count}M" if minutes_count > 0

                if seconds > 0
                  iseconds = seconds.to_i
                  fseconds = seconds.round(3)
                  display << "#{fseconds == iseconds ? iseconds : fseconds}S"
                end
              end
            end
          end
        end
      end
    end
  end
end
