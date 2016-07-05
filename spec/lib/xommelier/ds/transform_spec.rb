# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::DS::Transform do
  it { is_expected.to respond_to(:xpath) }

  describe '.new_xslt' do
    subject { described_class.new_xslt }
    its('algorithm.to_s') { should == 'http://www.w3.org/TR/1999/REC-xslt-19991116' }
    its('algorithm_name') { should == :xslt }
  end

  describe '.new_xpath' do
    subject { described_class.new_xpath }
    its('algorithm.to_s') { should == 'http://www.w3.org/TR/1999/REC-xpath-19991116' }
    its('algorithm_name') { should == :xpath }
  end

  describe '.new_enveloped_signature' do
    subject { described_class.new_enveloped_signature }
    its('algorithm.to_s') { should == 'http://www.w3.org/2000/09/xmldsig#enveloped-signature' }
    its('algorithm_name') { should == :enveloped_signature }
  end
end
