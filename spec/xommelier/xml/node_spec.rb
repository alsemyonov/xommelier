require 'spec_helper'

describe Xommelier::Xml::Node do
  describe 'class' do
    subject { Xommelier::Xml::Node }

    it { should respond_to(:new) }

    describe 'instantiating' do
      before do
        @xml = Nokogiri::XML('<?xml version="1.0" encoding="utf-8"?><text>Text</text>')
        @hash = {text: 'Text'}
        @text = 'Text'
      end

      it { expect { Xommelier::Xml::Node.new(@xml) }.not_to raise_error  }
      it { expect { Xommelier::Xml::Node.new(@hash) }.not_to raise_error  }
      it { expect { Xommelier::Xml::Node.new(@text) }.not_to raise_error  }
    end
  end
end
