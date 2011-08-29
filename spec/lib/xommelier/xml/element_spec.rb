require 'spec_helper'

describe Xommelier::Xml::Element do
  describe 'class' do
    subject { NamespacedModule::EmptyRoot }

    it { should respond_to(:xmlns) }
    it { subject.xmlns.to_s.should == 'http://example.org/' }

    it { should respond_to(:element_name) }
    it { subject.element_name.should == 'empty-root' }
  end

  describe 'instance' do
    subject { NamespacedModule::EmptyRoot.new }

    it { should respond_to(:to_xml) }
    it { subject.to_xml.should == %(<?xml version="1.0"?>\n<empty-root xmlns="http://example.org/"/>\n) }

    describe 'with text' do
      subject { NamespacedModule::RootWithText.new('Text') }

      it { should respond_to(:text) }
      it { subject.text.should == 'Text' }
      it { subject.to_xml.should == %(<?xml version="1.0"?>\n<root-with-text xmlns="http://example.org/">Text</root-with-text>\n) }
    end

    describe 'with simple subelements' do
      subject { NamespacedModule::RootWithSimpleSubelement.new(some: 'Text') }

      it { should respond_to(:some) }
      it { subject.some.should == 'Text' }
      it { subject.to_xml.should == %(<?xml version="1.0"?>\n<root-with-simple-subelement xmlns="http://example.org/">\n  <some>Text</some>\n</root-with-simple-subelement>\n) }
    end

    describe 'with many simple subelements' do
      subject do
        NamespacedModule::RootWithManySimpleSubelements.new(foos: ['bar', 'baz'])
      end

      it { should respond_to(:foo) }
      it { subject.foos.should == ['bar', 'baz'] }
      it { subject.foo.should == 'bar' }
      it { subject.to_xml.should == %(<?xml version="1.0"?>\n<root-with-many-simple-subelements xmlns="http://example.org/">\n  <foo>bar</foo>\n  <foo>baz</foo>\n</root-with-many-simple-subelements>\n) }
    end

    describe 'with attribute' do
      subject { NamespacedModule::RootWithAttribute.new(another: 'Difference') }

      it { should respond_to(:another) }
      it { subject.another.should == 'Difference' }
      it { subject.to_xml.should == %(<?xml version="1.0"?>\n<root-with-attribute xmlns="http://example.org/" another="Difference"/>\n) }
    end

    describe 'with subelements' do
      subject do
        NamespacedModule::RootWithSubelement.new(
          one: Date.new(2011, 8, 15),
          two: '2',
          some: 'Text',
          another: {some: 'Text'}
        )
      end

      it { should respond_to(:one) }
      it { should respond_to(:two) }
      it { should respond_to(:some) }
      it { should respond_to(:another) }
      it { subject.another.class.should == NamespacedModule::RootWithSimpleSubelement }
      it { subject.another.some.should == 'Text' }
      it { subject.to_xml.should == %(<?xml version="1.0"?>\n<root-with-subelement xmlns="http://example.org/" one="2011-08-15" two="2">\n  <some>Text</some>\n  <another>\n    <some>Text</some>\n  </another>\n</root-with-subelement>\n) }
    end
  end
end
