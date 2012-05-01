require 'spec_helper'

describe Xommelier::Xml::Node do
  context 'class' do
    subject { Xommelier::Xml::Node }

    it { should respond_to(:fields) }
    its(:fields) { should == {} }

    it { should respond_to(:field_names) }
    its(:field_names) { should == [] }

    it { should respond_to(:defaults) }
    its(:defaults) { should == {} }

    it { should respond_to(:lookup_undefined_fields) }
    its(:lookup_undefined_fields) { should == true }

    it { should respond_to(:field) }
    it { should respond_to(:element) }
    it { should respond_to(:attribute) }
    it { should respond_to(:text) }
    it { should respond_to(:any) }
    it { should respond_to(:many) }
    it { should respond_to(:may) }
  end

  context 'instance' do
    subject { Xommelier::Xml::Node.new }

    it { should respond_to(:attributes) }
    its(:attributes) { should be_kind_of(Xommelier::Xml::AttributesProxy) }
    it { should respond_to(:attributes=) }
    it { should respond_to(:[]) }
    #it { should respond_to(:[]=) }
    it { should respond_to(:read_attribute) }
    #it { should respond_to(:write_attribute) }
  end
end
