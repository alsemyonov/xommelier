# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

class Symbol
  def self.from_xommelier(value)
    value.to_sym
  end

  def to_xommelier
    to_s
  end
end
