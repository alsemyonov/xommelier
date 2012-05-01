require 'spec_helper'

describe Xommelier::Xml::Schema do
  let(:schema) { Atom.schema }
  subject { schema }

  its(:name) { should == :atom }

  ##
  # Module for containing types
  ##
  its(:module_name) { should == 'Atom' }
  context '#module' do
    subject { schema.module }

    it { should be_instance_of(Module) }
    it { should == Xommelier::Schemas::Atom }
    %w(namespace xmlns ns element attribute complex_type simple_type).each do |method_name|
      it { should respond_to(method_name) }
    end
  end

  # global elements and element definition
  it { should respond_to(:element) }
  it { should respond_to(:elements) }
  describe '#elements' do
    subject { schema.elements }

    it { subject[:feed].should be_instance_of(Xommelier::Xml::Schema::Field) }
    it { subject[:feed].type.should == Xommelier::Schemas::Atom::Feed }
    its(:count) { should == 2 }
  end

  ##
  # Defining global complex types
  ##
  it { should respond_to(:complex_type) }

  ##
  # Setting local namespace
  ##
  it { should respond_to(:namespace) }
  describe '#namespace' do
    subject { schema.namespace }

    its(:href) { should == ATOM_XMLNS }
    its(:prefix) { should == :atom }
  end

  ##
  # Namespaces definition and importing
  ##
  it { should respond_to(:import) }
  it { should respond_to(:namespaces) }
  it { should respond_to(:ns) }
  describe '#ns' do
    subject { schema.ns }

    it { should respond_to(:atom) }

    it { Atom.should == Xommelier::Schemas::Atom }
    it { Atom.should be_instance_of(Module) }

    its('atom.feedType') { should == Atom::Feed }
    its('atom.emailType') { should == Atom::Email }
    its('atom.someNewType') { should == Atom::SomeNew }
  end
end
