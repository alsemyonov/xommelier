require 'spec_helper'

describe Xommelier::Xml::Schema::ComplexType::ComplexContent do
  let(:type) { Atom::Person }
  let(:instance) { type.new }
  subject { type }

  it { subject.options[:_content].should == :complex }
  it { expect { Atom::Person.simple_content }.to raise_error Xommelier::ComplexContentTypeError }
  its(:included_modules) { should include(Xommelier::Xml::Schema::ComplexType, described_class)  }

  context 'instance' do
    subject { instance }

    it { should respond_to(:name) }
    it { should respond_to(:uri) }

    #it_behaves_like 'ActiveModel'

    its(:attributes) { should == {} }
    its(:name) { should == nil }
    its(:email) { should == nil }
    its(:uri) { should == nil }

    context 'serialization' do
      before do
        subject.name = 'Example Name'
        subject.email = 'name@example.com'
      end

      its(:name)  { should == 'Example Name' }
      its(:name) { should be_instance_of(Xommelier::Schemas::XmlSchema::String) }
      its(:email) { should == 'name@example.com' }
      its(:email) { should be_instance_of(Xommelier::Schemas::Atom::Email) }
      its(:attributes) do
        should == {
          'name'  =>  'Example Name',
          'email' =>  'name@example.com'
        }
      end
      it do
        should == {
          'name'  =>  'Example Name',
          'email' =>  'name@example.com'
        }
      end
    end
  end
end
