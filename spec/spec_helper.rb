root = File.expand_path('../..', __FILE__)
$:<< File.join(root, 'lib')
require 'rspec'
require 'xommelier'
require 'namespaced_module'

Dir[File.join(root, 'spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end
