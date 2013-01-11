require 'spec_helper'

describe Xommelier::RSS::EmailAddress do
  {
    'al@semyonov.us' => ['al@semyonov.us', nil],
    'al@semyonov.us (Alexander)' => ['al@semyonov.us', 'Alexander'],
    'al@semyonov.us (Alexander Semyonov)' => ['al@semyonov.us', 'Alexander Semyonov']
  }.each do |email_address, (address, name)|
    it "parses #{email_address.inspect} as address:#{address.inspect}, name:#{name.inspect}" do
      e = described_class.from_xommelier(email_address)
      e.should == address
      e.name.should == name
    end

    it "produces #{email_address.inspect} from address:#{address.inspect}, name:#{name.inspect}" do
      e = described_class.new
      e.address = address
      e.name = name
      e.to_xommelier.should == email_address
    end
  end
end
