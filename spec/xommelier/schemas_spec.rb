require 'spec_helper'

describe Xommelier::Schemas do
  before do
    require 'support/simple_atom'
  end

  it 'should define schemas as submodules' do
    expect { Xommelier::Schemas::Atom }.not_to raise_error(NameError)
  end

  context '.cleanup!', :unless do
    before do
      subject.cleanup!
    end

    it 'should clean all defined namespaces' do
      expect { Xommelier::Schemas::Atom }.to raise_error(NameError, 'uninitialized constant Xommelier::Schemas::Atom')
    end
  end
end
