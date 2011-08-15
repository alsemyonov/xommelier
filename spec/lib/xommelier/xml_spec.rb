require 'spec_helper'

describe Xommelier::Xml do
end

describe NamespacedModule do
  subject { NamespacedModule }

  it { should respond_to(:xmlns) }
  it { subject.xmlns.to_s.should == 'http://example.org/' }
end
