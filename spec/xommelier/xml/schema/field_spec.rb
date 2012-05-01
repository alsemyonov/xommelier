require 'spec_helper'

require 'support/simple_atom'

describe Xommelier::Xml::Schema::Field do
  subject { field }

  let(:field) { described_class.new(field_name, field_options) }
  let(:field_options) { {} }

  context '(node_type: element)' do
    let(:field_name) { :entry }
    let(:field_options) { {node_type: :element} }

    it { should be_kind_of(described_class) }
    its(:name)                { should == 'entry' }
    its(:type)                { should == XmlSchema::String }
    its(:node_type)           { should == :element }
    its(:method_name)         { should == :entry }
    its(:getter)              { should == :entry }
    its(:setter)              { should == :entry= }
    its(:presence)            { should == :entry? }
    its(:plural_method_name)  { should == :entries }
    its(:plural_getter)       { should == :entries }
    its(:plural_setter)       { should == :entries= }
    its(:plural_presence)     { should == :entries? }
    its(:default)             { should be_nil }
    its(:plural?)             { should be_false }
    its(:finder_method)       { should == :at_xpath }
    its(:xpath)               { should == ['entry'] }

    context 'with namespace' do
      let(:field_options) { {node_type: :element, type: ATOM::Entry} }

      its(:xmlns) { should == ATOM.xmlns }
      its('xmlns.prefix') { should == :atom }
      its(:xpath) { should == ['atom:entry', ATOM.xmlns.to_hash] }
    end
  end

  context '(node_type: :attribute)' do
    let(:field_name) { :href }
    let(:field_options) { {node_type: :attribute, type: XmlSchema::AnyURI} }

    its(:xpath) { should == ['@href'] }

    context 'with namespace' do
      let(:field_options) { {node_type: :attribute, type: XmlSchema::AnyURI, xmlns: ATOM.xmlns} }

      its(:xpath) { should == ['@href'] }
    end
  end
  context '(node_type: :content)' do
    let(:field_name) { :href }
    let(:field_options) { {node_type: :content, type: XmlSchema::AnyURI} }

    its(:xpath) { should == ['text()'] }

    context 'with namespace' do
      let(:field_options) { {node_type: :content, type: XmlSchema::AnyURI, xmlns: ATOM.xmlns} }

      its(:xpath) { should == ['text()'] }
    end
  end
end
