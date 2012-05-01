require 'spec_helper'
require 'support/simple_atom'

describe Xommelier::Xml::Schema::Type do
  it { ATOM::Person.should_not == ATOM::Email }
  it { ATOM::Person.xmlns.should == ATOM.xmlns }

  context ATOM::Email do
    subject { ATOM::Email }

    it { should < Xommelier::Xml::Schema::Type }
    it { should_not respond_to(:element) }
    it { should_not respond_to(:sequence) }
    its(:base) { should == XmlSchema::String }
  end

  context ATOM::Uri do
    subject { ATOM::Uri }

    it { should < Xommelier::Xml::Schema::Type }
    it { should_not respond_to(:element) }
    its(:base) { should == XmlSchema::AnyURI }
  end

  context ATOM::Generator do
    subject { ATOM::Generator }

    it { should < Xommelier::Xml::Schema::Type }
    it { should_not respond_to(:element) }
    it { should respond_to(:attribute) }
    it { should respond_to(:attributes) }
    its(:base) { should == XmlSchema::String }

    its(:attributes) { should include(:uri) }
    its(:attributes) { should include(:version) }
  end
end
