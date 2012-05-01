require 'rspec'
require 'xommelier/xml/schema/complex_type'

shared_examples_for 'Complex Type' do
  let(:attributes) { type.attributes }
  let(:elements) { type.elements }
  let(:instance) { type.new }

  subject { type }

  it_behaves_like 'XML Schema Type' do
    it { should be_complex }
    its(:included_modules) { should include(Xommelier::Xml::Schema::ComplexType) }

    it { should respond_to(:attributes) }

    context 'instance' do
      subject { instance }

      it { should respond_to(:attributes) }
      it { should respond_to(:to_hash) }
    end
  end
end
