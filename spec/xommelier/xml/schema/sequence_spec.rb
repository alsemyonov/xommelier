require 'spec_helper'

describe Xommelier::Xml::Schema::Sequence do
  it_behaves_like 'Explicit Group' do
    context 'instance' do
      subject { instance}

      it { should respond_to(:elements) }
      it { should respond_to(:element) }
    end
  end
end
