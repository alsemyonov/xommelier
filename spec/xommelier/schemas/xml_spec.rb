require 'spec_helper'
require 'xommelier/schemas/xml'

xml = Xommelier::Schemas::Xml.namespace
describe xml do
  describe 'xml:lang' do
    subject { xml.lang }

    it { should be_instance_of(Xommelier::Xml::Schema::Field) }
    its(:name) { should == 'lang' }
    its(:type) { should == XmlSchema::Language }
  end

  describe 'xml:base' do
    subject { xml.base }

    it { should be_instance_of(Xommelier::Xml::Schema::Field) }
    its(:name) { should == 'base' }
    its(:type) { should == XmlSchema::AnyURI }
  end

  describe 'xml:space' do
    subject { xml.space }

    it { should be_instance_of(Xommelier::Xml::Schema::Field) }
    its(:name) { should == 'space' }
    its(:type) { should < Xommelier::Xml::Schema::Type }
  end
end
