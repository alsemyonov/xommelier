# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::DS::CanonicalizationMethod do
  it { is_expected.to respond_to(:algorithm) }

  describe '.new_omit_comments' do
    subject { described_class.new_omit_comments }
    its('algorithm.to_s') { should == 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315' }
  end

  describe '.new_with_comments' do
    subject { described_class.new_with_comments }
    its('algorithm.to_s') { should == 'http://www.w3.org/TR/2001/REC-xml-c14n-20010315#WithComments' }
  end
end
