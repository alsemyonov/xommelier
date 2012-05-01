require 'spec_helper'

describe Xommelier::Schemas do
  it 'should define schemas as submodules' do
    expect { Xommelier::Schemas::Atom }.not_to raise_error(NameError)
  end

  # Remove unless option only if you need to test cleaning up schema definitions
  context '.cleanup!', unless: true do
    before do
      subject.cleanup!
    end
    after do
      load 'lib/xommelier/schemas/xml.rb'
      load 'lib/xommelier/schemas/atom.rb'
    end

    it 'should clean all defined namespaces' do
      expect { Xommelier::Schemas::Atom }.to raise_error(NameError, 'uninitialized constant Xommelier::Schemas::Atom')
    end
  end
end
