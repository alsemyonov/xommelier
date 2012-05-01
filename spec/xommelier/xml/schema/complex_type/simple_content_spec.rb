require 'spec_helper'

describe Xommelier::Xml::Schema::ComplexType::SimpleContent do
  let(:type) { ATOM::Generator  }
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
    it { content.type.should == ATOM::Generator }
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
    its(:to_hash) { should == {'content'=>nil, 'uri'=>nil, 'version'=>nil,'lang'=>nil} }

    its(:to_s) { should == '' }
  end
end
