# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::DS::DigestMethod do
  describe '.new_sha1' do
    subject { described_class.new_sha1 }
    its('algorithm.to_s') { should == 'http://www.w3.org/2000/09/xmldsig#sha1' }
  end
end
