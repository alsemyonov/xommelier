require 'spec_helper'

describe Xommelier::Xml::Schema::AttributeGroup do
  it_behaves_like 'Explicit Group' do
    let(:instance) { described_class.new(:commonAttributes, schema: XmlSchema) }

    context 'instance' do
      subject { instance }

      it { should respond_to(:name) }
      it { should respond_to(:attributes) }
      it { should respond_to(:attribute) }
      it { should respond_to(:attribute_group) }
    end
  end

  context 'Simple Atom' do
    subject { Atom.namespace.commonAttributes }

    it { should be_instance_of(Xommelier::Xml::Schema::AttributeGroup) }
    it { should respond_to(:fields) }
    it { should have(0).fields }
  end
end
