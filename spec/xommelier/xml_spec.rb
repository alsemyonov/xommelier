require 'spec_helper'

describe Xommelier::Xml do
end

describe Xommelier::Atom do
  subject { Xommelier::Atom }

  it { should respond_to(:xmlns) }
  it { subject.xmlns.to_s.should == ATOM_XMLNS }
  its(:xsd) { should_not be_nil }
end
