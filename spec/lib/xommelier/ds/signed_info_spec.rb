# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::DS::SignedInfo do
  it { is_expected.to respond_to(:canonicalization_method) }
  it { is_expected.to respond_to(:signature_method) }
  it { is_expected.to respond_to(:reference) }
end
