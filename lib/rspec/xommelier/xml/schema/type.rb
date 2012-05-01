require 'rspec'
require 'xommelier/xml/schema/type'

shared_examples_for 'XML Schema Type' do
  it { should be_instance_of(Class) }
  it { should < Xommelier::Xml::Schema::Type }
  it { should respond_to(:deserialize) }

  context 'instance' do
    subject { instance }

    it { should respond_to(:serialize) }
    it { should respond_to(:to_xml) }
  end
end
