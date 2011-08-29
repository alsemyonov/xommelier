SPEC_ROOT = File.expand_path('../..', __FILE__)
$:<< File.join(SPEC_ROOT, 'lib')

require 'rspec'
require 'xommelier'
require 'namespaced_module'

Dir[File.join(SPEC_ROOT, 'spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end
