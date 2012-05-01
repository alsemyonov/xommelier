SPEC_ROOT = File.expand_path('../..', __FILE__)
require 'bundler/setup'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter 'lib/rspec/xommelier'
  add_filter 'lib/yard/xommelier'

  add_group 'Xml::Schema', 'lib/xommelier/xml/schema'
  add_group 'XML Schema Datatypes', 'lib/xommelier/schemas/xml_schema'
  HELPERS_GROUP = %w[
    lib/xommelier/with_references
    lib/xommelier/core_ext
    lib/xommelier/collection
    lib/xommelier/utils
  ].map { |path| Regexp.compile(Regexp.quote(path)) }
  add_group 'Helpers' do |src_file|
    HELPERS_GROUP.any? { |helper| src_file.filename =~ helper }
  end
end

require 'rspec'
require 'xommelier'
require 'rspec/xommelier'
require 'active_support/core_ext/time/zones'
Time.zone = 'UTC'

Dir[File.join(SPEC_ROOT, 'spec/support/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
  config.treat_symbols_as_metadata_keys_with_true_values = true
end
