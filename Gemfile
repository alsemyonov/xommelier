source 'http://rubygems.org'

# Specify your gem's dependencies in xommelier.gemspec
gemspec

group :development, :test do
  gem 'rb-inotify'
  gem 'libnotify'
  gem 'rb-fsevent'
  gem 'ruby_gntp'
  gem 'guard'
  gem 'guard-rspec'
  gem 'guard-bundler'
end

group :development do
  gem 'ripl'
  gem 'ripl-auto_indent',  require: 'ripl/auto_indent'
  gem 'ripl-color_error',  require: 'ripl/color_error'
  gem 'ripl-color_result', require: 'ripl/color_result'
  gem 'ripl-multi_line',   require: 'ripl/multi_line'
  gem 'ripl-rails',        require: 'ripl/rails'
  gem 'ripl-rocket',       require: 'ripl/rocket'
end

group :doc do
  gem 'yard'
  gem 'yard-delegate'
  gem 'redcarpet'
  gem 'guard-yard'
end
