require 'rspec'
require 'xommelier/xml/schema/simple_type'

shared_examples_for 'Simple Type' do |options|
  options ||= {}
  let(:type) { described_class }
  let(:instance) { type.new(value) }
  let(:value) { nil }

  subject { type }

  it_behaves_like 'XML Schema Type'

  it { should be_simple }
  deserializes = options.fetch(:deserializes, {})
  raises = options.fetch(:raises, [])
  not_raises = options.fetch(:not_raises, [])
  if deserializes.any? || raises.any? || not_raises.any?
    context '.deserialize' do
      deserializes.each do |from, to|
        it("deserializes #{from.inspect} to #{to.inspect}") { described_class.deserialize(from).should == to }
      end
      raises.each do |value|
        it "Should raise TypeError on #{value.class} #{value.inspect} value" do
          expect { described_class.new(value) }.to raise_error Xommelier::DeserializationError
        end
      end
      not_raises.each do |value|
        it "Should not raise TypeError on #{value.class} #{value.inspect} value" do
          expect { described_class.new(value) }.not_to raise_error Xommelier::DeserializationError
        end
      end
    end
  end

  context 'instance' do
    subject { instance }

    options.fetch(:serializes, {}).each do |from, to|
      context "serializes #{from.inspect} to #{to.inspect}" do
        before { subject.value = from }

        its(:serialize) { should == to }
      end
    end
  end
end
