require 'spec_helper'

describe Xommelier::Xml::Element do
  describe 'class' do
    subject { Xommelier::Atom::Link }

    it { should respond_to(:xmlns) }
    it { subject.xmlns.to_s.should == ATOM_XMLNS }

    it { should respond_to(:element_name) }
    it { subject.element_name.should == 'link' }
  end

  describe 'instance' do
    subject { Xommelier::Atom::Link.new }

    it { should respond_to(:to_xml) }
    it { subject.to_xml.should == %(<?xml version="1.0" encoding="utf-8"?>\n<link xmlns="#{ATOM_XMLNS}"/>\n) }

    describe 'with text' do
      subject { Xommelier::Atom::Generator.new('Text') }

      it { should respond_to(:text) }
      it { subject.text.should == 'Text' }
      it { subject.to_xml.should == %(<?xml version="1.0" encoding="utf-8"?>\n<generator xmlns="#{ATOM_XMLNS}">Text</generator>\n) }
    end

    describe 'with simple subelements' do
      subject { Xommelier::Atom::Person.new(name: 'Ivan') }

      it { should respond_to(:name) }
      it { subject.name.should == 'Ivan' }
      it { subject.to_xml.should == %(<?xml version="1.0" encoding="utf-8"?>\n<person xmlns="#{ATOM_XMLNS}">\n  <name>Ivan</name>\n</person>\n) }
    end

    describe 'with many simple subelements' do
      subject do
        Xommelier::Atom::Feed.new(entries: [{title: 'bar'}, {title: 'baz'}])
      end

      it { should respond_to(:entry) }
      it { subject.entries.should == ['bar', 'baz'] }
      it { subject.entry.should == 'bar' }
      it { subject.to_xml.should == %(<?xml version="1.0" encoding="utf-8"?>\n<feed xmlns="#{ATOM_XMLNS}">\n  <entry>\n    <title>bar</title>\n  </entry>\n<entry>\n    <title>bar</title>\n  </entry>\n</feed>\n) }
    end

    describe 'with attribute' do
      subject { Xommelier::Atom::Link.new(href: 'http://example.com/') }

      it { should respond_to(:href) }
      it { subject.href.should == 'Difference' }
      it { subject.to_xml.should == %(<?xml version="1.0" encoding="utf-8"?>\n<link xmlns="#{ATOM_XMLNS}" href="http://example.com/"/>\n) }
    end

    describe 'with subelements' do
      subject do
        Xommelier::Atom::Entry.new(
          title: 'Text',
          published: Time.utc(2011, 8, 15),
          author: {name: 'Text'}
        )
      end

      it { should respond_to(:title) }
      it { should respond_to(:published) }
      it { should respond_to(:author) }
      it { subject.author.class.should == Xommelier::Atom::Person }
      it { subject.author.name.should == 'Text' }
      it { subject.to_xml.should == %(<?xml version="1.0" encoding="utf-8"?>\n<root-with-subelement xmlns="http://example.org/" one="2011-08-15" two="2">\n  <some>Text</some>\n  <another>\n    <some>Text</some>\n  </another>\n</root-with-subelement>\n) }
    end
  end
end
