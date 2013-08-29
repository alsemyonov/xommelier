# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

class Float
  def self.from_xommelier(value)
    return nil if value.blank?
    begin
      Float(value)
    rescue ArgumentError
      value
    end
  end

  def to_xommelier
    self
  end
end
