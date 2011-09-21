require 'spec_helper'

describe Xommelier::Xml::Node do
  subject { Xommelier::Xml::Node.new }

  it { should respond_to(:attributes) }
  it { should respond_to(:attributes=) }
end
