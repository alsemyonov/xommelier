# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'xommelier/version'

Gem::Specification.new do |s|
  s.name        = 'xommelier'
  s.version     = Xommelier::VERSION
  s.authors     = ['Alexander Semyonov']
  s.email       = %w(al@semyonov.us)
  s.homepage    = 'http://github.com/alsemyonov/xommelier'
  s.summary     = %q{Xommelier is an XML Sommelier}
  s.description = %q{XML-Object Mapper with many built-in XML formats supported}
  s.license     = 'MIT'

  s.rubyforge_project = 'xommelier'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)

  s.add_dependency 'nokogiri', '~> 1.6.8'
  s.add_dependency 'activesupport', '~> 4.2.2'
  s.add_dependency 'activemodel'
  s.add_dependency 'tzinfo', '~> 1.1'

  s.add_development_dependency 'rspec', '~> 2.99.0'
  s.add_development_dependency 'rspec-its', '~> 1.0.1'
  s.add_development_dependency 'rake', '~> 10.4.2'
  s.add_development_dependency 'yard', '~> 0.8.7.6'
  s.add_development_dependency 'simplecov', '~> 0.6.1'
  s.add_development_dependency 'redcarpet', '>= 3.2.3'
end
