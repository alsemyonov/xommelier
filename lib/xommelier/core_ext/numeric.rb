# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

class Numeric
  def self.from_xommelier(value)
    return nil if value.blank?
    begin
      value.match?(/\./) ? Float(value) : Integer(value)
    rescue ArgumentError
      value
    end
  end

  def to_xommelier
    self
  end
end
