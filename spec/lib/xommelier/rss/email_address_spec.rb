# coding: utf-8

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::RSS::EmailAddress do
  {
    'al@semyonov.us' => ['al@semyonov.us', nil],
    'al@semyonov.us (Alexander)' => ['al@semyonov.us', 'Alexander'],
    'al@semyonov.us (Alexander Semyonov)' => ['al@semyonov.us', 'Alexander Semyonov']
  }.each do |email_address, (address, name)|
    it "parses #{email_address.inspect} as address:#{address.inspect}, name:#{name.inspect}" do
      e = described_class.from_xommelier(email_address)
      expect(e).to eq(address)
      expect(e.name).to eq(name)
    end

    it "produces #{email_address.inspect} from address:#{address.inspect}, name:#{name.inspect}" do
      e = described_class.new
      e.address = address
      e.name = name
      expect(e.to_xommelier).to eq(email_address)
    end
  end
end
