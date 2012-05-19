guard :bundler do
  watch('Gemfile')
  watch(/^.+\.gemspec/)
end

guard :rspec, all_on_start: false, all_after_pass: false do
  watch('spec/spec_helper.rb')
  watch(%r{^spec/fixtures/.+$})
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
end

def kill_yard_if_needed
  Process.kill(9, $yard_server) if $yard_server
end

def yard_server
  kill_yard_if_needed
  $yard_server = spawn('yard server', out: 'log/yard.log', err: 'log/yard.log')
  Process.detach($yard_server)
end

guard :shell do
  watch('.yardopts') do |m|
    n "#{m[0]} has been changed", 'Restarting YARD server', :pending
    yard_server
  end
end

yard_server
at_exit { kill_yard_if_needed }
