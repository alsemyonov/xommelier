SPEC_ROOT = File.expand_path('../..', __FILE__)
require 'simplecov'
require 'bundler/setup'
require 'rspec'

SimpleCov.start

require 'xommelier'
require 'namespaced_module'

#noinspection RubyResolve
Dir[File.join(SPEC_ROOT, 'spec/support/**/*.rb')].each {|f| require f}

ATOM_XMLNS = 'http://www.w3.org/2005/Atom'

#noinspection RubyResolve
RSpec.configure do |config|
  config.mock_with :rspec
  config.order = 'random'
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
