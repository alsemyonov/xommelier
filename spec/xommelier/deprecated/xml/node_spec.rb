require 'spec_helper'

__END__

describe Xommelier::Xml::Node do
  describe 'class' do
    subject { Xommelier::Xml::Node }

    it { should respond_to(:new) }

    describe 'instantiating' do
      let(:xml) { Nokogiri::XML('<?xml version="1.0" encoding="utf-8"?><text>Text</text>') }
      let(:hash) { {text: 'Text'} }
      let(:text) { 'Text' }

      it { expect { Xommelier::Xml::Node.new(xml) }.not_to raise_error  }
      it { expect { Xommelier::Xml::Node.new(hash) }.not_to raise_error  }
      it { expect { Xommelier::Xml::Node.new(text) }.not_to raise_error  }
    end
  end

  describe 'instance' do
    let(:node) { Xommelier::Xml::Node.new }
    subject { node }

    its(:xml_document) { should be_present }
  end
end
