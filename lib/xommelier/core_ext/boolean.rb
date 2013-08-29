# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Authors: Alexander Semyonov <al@semyonov.us> #
#          Artyom Semyonov <sevenov@gmail.com> #
################################################

require 'xommelier'

class Boolean
  #noinspection RubyStringKeysInHashInspection,RubyDuplicatedKeysInHashInspection
  BOOLEAN_MAP = {
    true => true, 'true' => true, 'TRUE' => true, '1' => true, '1.0' => true, 1 => true, 1.0 => true,
    false => false, 'false' => false, 'FALSE' => false, '0' => false, '0.0' => false, 0 => false, 0.0 => false, nil => false, '' => false
  }

  def self.from_xommelier(value)
    BOOLEAN_MAP[value]
  end
end

class TrueClass
  def to_xommelier
    self
  end
end

class FalseClass
  def to_xommelier
    self
  end
end
