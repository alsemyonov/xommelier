# frozen_string_literal: true

$LOAD_PATH.push Pathname(__dir__).join('lib')
require 'xommelier/version'

Gem::Specification.new do |s|
  s.name = 'xommelier'
  s.version = Xommelier::VERSION
  s.authors = ['Alexander Semyonov']
  s.email = %w[al@semyonov.us]
  s.homepage = 'https://gitlab.com/alsemyonov/xommelier'
  s.summary = 'Xommelier. The XML Sommelier'
  s.description = 'XML-Object Mapper with many built-in XML formats supported'
  s.license = 'MIT'

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- exe/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = %w[lib]

  s.add_dependency 'activemodel'
  s.add_dependency 'activesupport', '>= 4.2.2'
  s.add_dependency 'nokogiri', '~> 1.8.3'
  s.add_dependency 'tzinfo', '~> 1.2'

  s.add_development_dependency 'bundler-audit'
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rspec-its', '~> 1.2.0'
  s.add_development_dependency 'rubocop', '~> 0.48'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov', '~> 0.13'
  s.add_development_dependency 'yard', '~> 0.9.11'
end
