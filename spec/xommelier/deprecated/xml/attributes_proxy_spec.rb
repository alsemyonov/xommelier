require 'spec_helper'

describe Xommelier::Xml::AttributesProxy do
  subject { proxy }

  let(:proxy) { node.attributes }

  context 'instance' do
    let(:node) { Xommelier::Xml::Node.new }

    it { should respond_to(:keys) }
    it { should respond_to(:each) }
    it { should respond_to(:values) }
    it { should respond_to(:count) }
    it { should respond_to(:to_hash) }
    it { should respond_to(:include?) }
    it { should respond_to(:merge!) }
    it { should respond_to(:[]) }
    #it { should respond_to(:[]=) }
    it { should respond_to(:read_attribute) }
    #it { should respond_to(:write_attribute) }
  end

  context Xommelier::Atom::Entry do
    ATOM_ENTRY_KEYS = %w(id title updated content published rights source summary author category contributor link)
    let(:node) { Xommelier::Atom::Entry.new }

    its(:keys) { should == ATOM_ENTRY_KEYS }
  end
end
