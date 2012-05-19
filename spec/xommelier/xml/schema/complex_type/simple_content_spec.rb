require 'spec_helper'

describe Xommelier::Xml::Schema::ComplexType::SimpleContent do
  let(:type) { Atom::Generator  }
  let(:instance) { type.new }
  subject { type }

  it { should be_simple_content }
  it { expect { subject.complex_content }.to raise_error Xommelier::ComplexContentTypeError }
  its(:included_modules) { should include(Xommelier::Xml::Schema::ComplexType, described_class)  }

  describe 'extensions' do
    subject { type.singleton_class }

    its(:included_modules) { should include(Xommelier::Xml::Schema::Attributes)  }
  end

  it { should have(4).fields }
  #its(:fields) { should include(:content) }
  its(:fields) { should include(:uri) }
  its(:fields) { should include(:version) }

  context 'content', :unless do
    let(:content) { type.fields[:content] }
    subject { content }

    it { content.name.should == 'content' }
    it { content.node_type.should == :content }
    it { content.type.should == Atom::Generator }
  end

  context 'instance' do
    subject { instance }

    #it_behaves_like 'ActiveModel'

    it { should respond_to(:value) }
    it { should respond_to(:content) }
    it { should respond_to(:uri) }
    it { should respond_to(:version) }

    its(:value) { should == nil }
    its(:content) { should == nil }
    its(:uri) { should == nil }
    its(:version) { should == nil }
    its(:to_hash) { should == {} }

    its(:to_s) { should == '' }

    context 'serialization' do
      before do
        subject.content = 'Xommelier'
        subject.uri = 'http://github.com/alsemyonov/xommelier'
        subject.version = Xommelier::VERSION
      end

      #it { puts subject.xml_node }
      its(:content)  { should == 'Xommelier' }
      its(:uri) { should == URI.parse('http://github.com/alsemyonov/xommelier') }
      its(:version) { should == Xommelier::VERSION }
      its(:attributes) do
        should == {
          'content' => 'Xommelier',
          'uri'     => URI.parse('http://github.com/alsemyonov/xommelier'),
          'version' => Xommelier::VERSION
        }
      end
      it { should == 'Xommelier' }
    end
  end
end
