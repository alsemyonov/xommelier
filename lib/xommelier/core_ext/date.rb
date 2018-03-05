# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'date'

class Date
  def self.from_xommelier(value)
    xmlschema(value)
  end

  def to_xommelier
    xmlschema
  end
end
