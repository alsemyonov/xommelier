require 'spec_helper'

describe Xommelier::Xml do
end

describe Xommelier::Atom do
  it { should respond_to(:xmlns) }
  it { subject.xmlns.to_s.should == ATOM_XMLNS }
  its(:schema) { should_not be_nil }
  it { puts Xommelier::Atom.schema }
end
