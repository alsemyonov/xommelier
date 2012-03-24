require 'spec_helper'

describe Xommelier::Xml::Serialization do
  describe 'class' do
    subject { Xommelier::Atom::Feed }

    it { should respond_to(:parse) }
  end
end
