# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

class String
  def self.from_xommelier(value)
    return nil if value.is_a?(NilClass)
    value.to_s
  end

  def to_xommelier
    self
  end
end
