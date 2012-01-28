SPEC_ROOT = File.expand_path('../..', __FILE__)
require 'bundler/setup'
require 'rspec'
require 'xommelier'
require 'namespaced_module'

Dir[File.join(SPEC_ROOT, 'spec/support/**/*.rb')].each {|f| require f}

ATOM_XMLNS = 'http://www.w3.org/2005/Atom'

RSpec.configure do |config|
  config.mock_with :rspec
end
