require 'spec_helper'

describe Xommelier::Xml::Schema::Type do
  it { Atom::Person.should_not == Atom::Email }
  it { Atom::Person.xmlns.should == Atom.xmlns }

  context Atom::Email do
    subject { Atom::Email }

    it { should < Xommelier::Xml::Schema::Type }
    it { should_not respond_to(:element) }
    it { should_not respond_to(:sequence) }
    its(:base) { should == XmlSchema::NormalizedString }
  end

  context Atom::Uri do
    subject { Atom::Uri }

    it { should < Xommelier::Xml::Schema::Type }
    it { should_not respond_to(:element) }
    its(:base) { should == XmlSchema::AnyURI }
  end

  context Atom::Generator do
    subject { Atom::Generator }

    it { should < Xommelier::Xml::Schema::Type }
    it { should_not respond_to(:element) }
    it { should respond_to(:attribute) }
    it { should respond_to(:attributes) }
    its(:base) { should == XmlSchema::String }

    its(:attributes) { should include(:uri) }
    its(:attributes) { should include(:version) }
  end
end
