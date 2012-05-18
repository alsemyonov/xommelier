shared_examples_for 'Explicit Group' do
  let(:instance) { described_class.new }

  context 'instance' do
    subject { instance }

    it { should respond_to(:generated_attribute_methods) }
    it { should respond_to(:each) }
    it { should respond_to(:[]) }
  end
end
