require 'spec_helper'

describe Xommelier::Xml::Serialization do
  subject { node }

  context 'class' do
    subject { Xommelier::Xml::Node }

    it { should respond_to(:parse) }
    it { should respond_to(:from_xml) }
    it { should respond_to(:from_xommelier) }
    it { should respond_to(:xmlns) }
    it { should respond_to(:node_name) }
  end

  context 'instance' do
    let(:node) { Xommelier::Xml::Node.new }

    it { should respond_to(:xml_node=) }
    it { should respond_to(:xml_node) }
    it { should respond_to(:xml_document) }
    it { should respond_to(:xml_parent) }
    it { should respond_to(:to_xml) }
  end

  context 'deserialization' do
    let(:xml)       { '<node />' }
    let(:document)  { Nokogiri::XML(xml) }
    let(:node)      { Xommelier::Xml::Node.new(document) }

    its(:xml_node) { should == document.root }
    its(:to_xml)   { should == %(<?xml version="1.0"?>\n<node/>\n) }
    its(:class)    { should respond_to(:parse) }

    it "should parse String, Nokogiri::XML::Node, and Xommelier::Xml::Node" do
      [xml, document, node].each do |source|
        Xommelier::Xml::Node.parse(source).to_xml.should == %(<?xml version="1.0"?>\n<node/>\n)
      end
    end
  end

  context 'serialization' do
    let(:node) { Xommelier::Atom::Entry.new(contents) }
    let(:contents) { nil }

    its(:xml_document) { should be_present }
    its(:to_xml) { should == %(<?xml version="1.0" encoding="utf-8"?>\n<entry xmlns="#{ATOM_XMLNS}"/>\n) }

    context '#xml_node' do
      subject { node.xml_node }

      it { should be_present }
      its(:name) { should == 'entry' }
    end

    context 'with subelements' do
      let(:contents) do
        {
          id:         'some-id',
          title:      'Some title',
          published:  Time.utc(2012, 3, 25),
        }
      end

      it { node.attributes.to_hash == contents }
      #its(:id) { should == 'some-id' }
      #its(:title) { should == 'Some title' }
      #its(:published) { should == Time.utc(2012, 3, 25) }
      #its(:to_xml) { should == %(<?xml version="1.0" encoding="utf-8"?>\n<entry xmlns="#{ATOM_XMLNS}>\n  <id>some-id</id>\n  <title>Some title</title>\n  <published>2012-03-25T00:00:00Z</published>\n</entry>\n) }
    end
  end
end
