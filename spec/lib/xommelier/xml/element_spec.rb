require 'spec_helper'

describe Xommelier::Xml::Element do
  describe 'class' do
    subject { NamespacedModule::EmptyRoot }

    it { should respond_to(:xmlns) }
    it { subject.xmlns.to_s.should == 'http://example.org/' }

    it { should respond_to(:element_name) }
    it { subject.element_name.should == 'empty-root' }

    it { should respond_to(:elements) }
    it { should respond_to(:attributes) }
  end

  describe 'DSL' do
    subject { NamespacedModule::Root }

    it { should respond_to(:element) }
    it 'defines subelement' do
      subject.elements.should have_key(:some)
    end
    it { should respond_to(:attribute) }
    it 'defines attribute'
    it { should respond_to(:text) }
    it 'defines as containing text'
  end

  describe 'instance' do
    subject { NamespacedModule::EmptyRoot.new }

    it { should respond_to(:to_xml) }
    it { subject.to_xml.should == %(<?xml version="1.0"?>\n<empty-root xmlns="http://example.org/"/>\n) }

    describe 'with subelements' do
      subject { NamespacedModule::Root.new(some: 'Text') }

      it { should respond_to(:some) }
      it { subject.some.should == 'Text' }
      it { subject.to_xml.should == %(<?xml version="1.0"?>\n<root xmlns="http://example.org/">\n  <some>Text</some>\n</root>\n) }
    end
  end
end
