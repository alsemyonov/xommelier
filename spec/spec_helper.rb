# frozen_string_literal: true

################################################
# © Alexander Semyonov, 2011—2013, MIT License #
# Author: Alexander Semyonov <al@semyonov.us>  #
################################################

SPEC_ROOT = File.expand_path('..', __dir__)
require 'simplecov'
require 'codeclimate-test-reporter'
# CodeClimate::TestReporter.start
require 'bundler/setup'
require 'rspec'
require 'rspec/its'

SimpleCov.start

require 'xommelier'

# noinspection RubyResolve
Dir[File.join(SPEC_ROOT, 'spec/support/**/*.rb')].each { |f| require f }

ATOM_XMLNS = 'http://www.w3.org/2005/Atom'.freeze

# noinspection RubyResolve
RSpec.configure do |config|
  config.mock_with :rspec
  config.order = 'random'
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true
end
