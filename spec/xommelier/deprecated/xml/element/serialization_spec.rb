require 'spec_helper'

__END__

describe Xommelier::Xml::Serialization do
  describe 'class' do
    subject { Xommelier::Atom::Feed }

    it { should respond_to(:parse) }
  end
end
