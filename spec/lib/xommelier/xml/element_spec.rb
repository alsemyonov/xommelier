# coding: utf-8
# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

require 'spec_helper'

describe Xommelier::Xml::Element do
  describe 'class' do
    subject { Xommelier::Atom::Link }

    it { is_expected.to respond_to(:xmlns) }
    it { expect(subject.xmlns.to_s).to eq(ATOM_XMLNS) }

    it { is_expected.to respond_to(:element_name) }
    it { expect(subject.element_name).to eq('link') }
  end

  describe 'instance' do
    subject { Xommelier::Atom::Link.new }

    it { is_expected.to respond_to(:to_xml) }
    it { expect(subject.to_xml).to eq(%(<?xml version="1.0" encoding="utf-8"?>\n<link xmlns="#{ATOM_XMLNS}"/>\n)) }

    describe 'with text' do
      subject { NamespacedModule::RootWithText.new('Text') }

      it { is_expected.to respond_to(:text) }
      it { expect(subject.text).to eq('Text') }
      it { expect(subject.to_xml).to eq(%(<?xml version="1.0" encoding="utf-8"?>\n<root-with-text xmlns="http://example.org/">Text</root-with-text>\n)) }
    end

    describe 'with simple subelements' do
      subject { Xommelier::Atom::Person.new(name: 'Ivan') }

      it { is_expected.to respond_to(:name) }
      it { expect(subject.name).to eq('Ivan') }
      it { expect(subject.to_xml).to eq(%(<?xml version="1.0" encoding="utf-8"?>\n<person xmlns="#{ATOM_XMLNS}">\n  <name>Ivan</name>\n</person>\n)) }
    end

    describe 'with many simple subelements' do
      subject do
        NamespacedModule::RootWithManySimpleSubelements.new(foos: %w(bar baz))
      end

      it { is_expected.to respond_to(:foo) }
      it { expect(subject.foos).to eq(%w(bar baz)) }
      it { expect(subject.foo).to eq('bar') }
      it { expect(subject.to_xml).to eq(%(<?xml version="1.0" encoding="utf-8"?>\n<root-with-many-simple-subelements xmlns="http://example.org/">\n  <foo>bar</foo>\n  <foo>baz</foo>\n</root-with-many-simple-subelements>\n)) }
    end

    describe 'with attribute' do
      subject { NamespacedModule::RootWithAttribute.new(another: 'Difference') }

      it { is_expected.to respond_to(:another) }
      it { expect(subject.another).to eq('Difference') }
      it { expect(subject.to_xml).to eq(%(<?xml version="1.0" encoding="utf-8"?>\n<root-with-attribute xmlns="http://example.org/" another="Difference"/>\n)) }
    end

    describe 'with subelements' do
      subject do
        NamespacedModule::RootWithSubelement.new(
          one: Date.new(2011, 8, 15),
          two: '2',
          some: 'Text',
          another: { some: 'Text' }
        )
      end

      it { is_expected.to respond_to(:one) }
      it { is_expected.to respond_to(:two) }
      it { is_expected.to respond_to(:some) }
      it { is_expected.to respond_to(:another) }
      it { expect(subject.another.class).to eq(NamespacedModule::RootWithSimpleSubelement) }
      it { expect(subject.another.some).to eq('Text') }
      it { expect(subject.to_xml).to eq(%(<?xml version="1.0" encoding="utf-8"?>\n<root-with-subelement xmlns="http://example.org/" one="2011-08-15" two="2">\n  <some>Text</some>\n  <another>\n    <some>Text</some>\n  </another>\n</root-with-subelement>\n)) }
    end
  end
end
