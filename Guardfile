guard 'bundler' do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard 'rspec', all_on_start: false, all_after_pass: false do
  watch('spec/spec_helper.rb')
  watch(%r{^spec/fixtures/.+$})
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end

guard 'yard' do
  watch(%r{app/.+\.rb$})
  watch(%r{lib/xommelier.*\.rb$})
  watch(%r{ext/.+\.c$})
end
