# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::Atom do
  it { is_expected.to respond_to(:xmlns) }
  it { expect(subject.xmlns.to_s).to eq(ATOM_XMLNS) }
  its(:schema) { should_not be_nil }
end
