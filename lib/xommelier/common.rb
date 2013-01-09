require 'xommelier'

module Xommelier
  module Common
    # A date-time displayed in RFC 822 format.
    class Time822 < Time
      def self.from_xommelier(value)
        case value
        when String
          value = rfc2822(value) rescue parse(value)
          at(value)
        when Time, Date, DateTime
          at(value.to_time)
        else
          raise TypeError, "Invalid value #{value.inspect} for Time822"
        end
      end

      def to_xommelier
        rfc822
      end
    end
  end
end
