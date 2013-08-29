# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'xommelier'
require 'xommelier/core_ext/string'
require 'uri'

class URI::Generic
  def to_xommelier
    to_s
  end
end

class Uri < String
  def self.from_xommelier(value)
    return if value == nil
    case value
    when URI::Generic
      value
    when String
      URI.parse(value)
    else
      raise Xommelier::TypeError.new(value, Uri)
    end
  end
end
