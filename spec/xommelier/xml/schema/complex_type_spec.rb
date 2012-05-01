require 'spec_helper'
require 'support/simple_atom'

describe Xommelier::Xml::Schema::ComplexType do
  let(:type) { ATOM::Person }
  let(:instance) { type.new }

  subject { type }

  it { should < Xommelier::Xml::Schema::Type }
  its(:included_modules) { should include(Xommelier::Xml::Schema::ComplexType)  }
  it { expect { subject.simple_type }.to raise_error Xommelier::ContentTypeError }

  context '.fields' do
    let(:generated_attribute_methods) { ATOM::Person.send(:generated_attribute_methods) }
    it { generated_attribute_methods.should be_kind_of(Module) }
    its(:included_modules) { should include(generated_attribute_methods)  }

    its(:fields) { should have(3).keys }
    it { subject.fields[:name].should be_kind_of Xommelier::Xml::Schema::Field }
  end

  context '.choice' do
    it { should respond_to(:choice) }
    its(:elements) { should include(:uri) }
    its(:elements) { should include(:name) }
  end

  it { should respond_to(:sequence) }
  it { should respond_to(:element) }
end
