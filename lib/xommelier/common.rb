# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier'

module Xommelier
  module Common
    # A date-time displayed in RFC 822 format.
    class Time822 < Time
      def self.from_xommelier(value)
        return unless value
        case value
        when String
          value = rfc2822(value) rescue parse(value)
          at(value)
        when Time, Date, DateTime
          at(value.to_time)
        else
          raise TypeError.new(value, self)
        end
      end

      def to_xommelier
        utc.rfc822
      end
    end
  end
end
