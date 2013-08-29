# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::Xml do
end

describe Xommelier::Atom do
  it { should respond_to(:xmlns) }
  it { subject.xmlns.to_s.should == ATOM_XMLNS }
  its(:schema) { should_not be_nil }
end
