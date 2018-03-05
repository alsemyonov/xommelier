# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::DS::SignatureMethod do
  it { is_expected.to respond_to(:hmac_output_length) }

  describe '.new_rsa_sha1' do
    subject { described_class.new_rsa_sha1 }
    its('algorithm.to_s') { should == 'http://www.w3.org/2000/09/xmldsig#rsa-sha1' }
  end

  describe '.new_dsa_sha1' do
    subject { described_class.new_dsa_sha1 }
    its('algorithm.to_s') { should == 'http://www.w3.org/2000/09/xmldsig#dsa-sha1' }
  end
end
