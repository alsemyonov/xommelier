# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::DS::Reference do
  it { is_expected.to respond_to(:digest_method) }
  it { is_expected.to respond_to(:digest_value) }
  it { is_expected.to respond_to(:uri) }
end
