# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "xommelier/version"

Gem::Specification.new do |s|
  s.name        = "xommelier"
  s.version     = Xommelier::VERSION
  s.authors     = ["Alexander Semyonov"]
  s.email       = ["al@semyonov.us"]
  s.homepage    = "http://github.com/alsemyonov/xommelier"
  s.summary     = %q{XML-Object Mapper}
  s.description = %q{XML-Object Mapper with many built-in XML formats supported}

  s.rubyforge_project = "xommelier"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'nokogiri', '~> 1.5.0'
  s.add_dependency 'activesupport', '~> 3.1'
  s.add_dependency 'activemodel', '~> 3.1'

  s.add_development_dependency 'rspec', '~> 2.9.0'
  s.add_development_dependency 'rake', '~> 0.9.2'
  s.add_development_dependency 'yard', '~> 0.7.3'
end
