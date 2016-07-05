# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'rspec'
shared_examples 'Valid XML Document' do
  it { expect(subject.class.schema).to be_present }
  specify { is_expected.to be_valid }
end
