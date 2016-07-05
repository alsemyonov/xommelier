# frozen_string_literal: true
require 'bundler/gem_tasks'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task default: :spec

require 'rubocop/rake_task'
RuboCop::RakeTask.new
task default: :rubocop

require 'yard'
YARD::Rake::YardocTask.new(:doc)
task default: :doc
