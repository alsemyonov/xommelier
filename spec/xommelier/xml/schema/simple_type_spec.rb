require 'spec_helper'

describe Xommelier::Xml::Schema::SimpleType do
  let(:type) { XmlSchema::Boolean }
  let(:instance) { type.new }

  subject { type }
  it { expect { subject.complex_type }.to raise_error Xommelier::ContentTypeError }
end
