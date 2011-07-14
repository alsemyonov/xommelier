root = $:<< File.expand_path('../..', __FILE__)
$:<< File.join(root, 'lib')
require 'rspec'

Dir[File.join(root, 'spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end
