require 'spec_helper'

XMLNS = 'http://www.w3.org/XML/1998/namespace'
describe Xommelier::Xml::Namespace do
  let(:namespace) { described_class.new(XMLNS, as: :xml) }

  subject { namespace }

  context 'href' do
    it { should respond_to(:href) }
    its(:href) { should == XMLNS }
  end

  context 'prefix' do
    it { should respond_to(:prefix) }
    its(:prefix) { should == :xml }
  end

  context 'registry' do
    subject { described_class.registry }

    it { should respond_to(:xml) }
    it { should == Xommelier.ns }
  end
end
