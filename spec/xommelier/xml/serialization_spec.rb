require 'spec_helper'

describe Xommelier::Xml::Node do
  let(:xml_string) { '<node />' }
  let(:nokogiri_doc) { @nokogiri_doc ||= Nokogiri::XML(xml_string) }
  subject { @node ||= Xommelier::Xml::Node.new(nokogiri_doc) }

  it { should respond_to(:xml_node=) }
  it { should respond_to(:xml_node) }
  it { should respond_to(:xml_document=) }
  it { should respond_to(:xml_document) }
  it { should respond_to(:to_xml) }

  its(:xml_node) { should == nokogiri_doc.root }
  its(:to_xml)   { should == %(<?xml version="1.0"?>\n<node/>\n) }
  its(:class)    { should respond_to(:parse) }

  it 'should parse strings and Nokogiri nodes' do
    [xml_string, nokogiri_doc].each do |xml|
      Xommelier::Xml::Node.parse(xml).to_xml.should == %(<?xml version="1.0"?>\n<node/>\n)
    end
  end
end
