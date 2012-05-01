require 'rspec'
require 'xommelier/xml/schema'

shared_examples_for 'XML Schema' do
  let(:module) { described_class }
  let(:schema) { described_class.schema }
  let(:namespace) { schema.namespace }
  let(:elements) { schema.elements }

  def self.it_has_global(items)
    context 'has global items' do
      subject { schema }

      items.each do |kind, items|
        its(kind) { should include(*items) }

        #context kind do
          #subject { schema.send(kind) }

          #items.each do |item|
            #it { should include(item) }
          #end
        #end
      end
    end
  end

  def self.its_element(name, &block)
    context "global element #{name}" do
      let(:element) { schema.elements[name] }
      subject { element }

      it { puts subject }
      its(:type) { should be_present }
      #block.call(binding) if block_given?
    end
  end
end
