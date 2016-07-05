# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'time'

class Time
  def self.from_xommelier(value)
    return if value.nil?
    case value
    when String
      Time.xmlschema(value)
    when Time
      value
    else
      raise Xommelier::TypeError.new(value, Time)
    end
  end

  def to_xommelier
    xmlschema
  end
end
