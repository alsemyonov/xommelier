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

    its(:attributes) { should == {'name'=>nil,'email'=>nil,'uri'=>nil} }
    its(:name) { should == nil }
    its(:email) { should == nil }
    its(:uri) { should == nil }

    context 'serialization' do
      before do
        subject.name = 'Example Name'
        subject.email = 'name@example.com'
        #instance.uri = 'http://ya.ru/'
        #puts subject.xml_node
        #puts subject.attributes
      end

      #it { puts subject.xml_node }
      its(:name)  { should == 'Example Name' }
      its(:email) { should == 'name@example.com' }
      its(:attributes) { should == {'name'=>'Example Name', 'email'=>'name@example.com', 'uri'=>nil} }
    end
  end
end
