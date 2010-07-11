#!/usr/bin/env ruby

def run_specs
  system('rake spec')
end

# Ctrl-\
Signal.trap('QUIT') do
  puts "\n--- Running all specs ---\n"
  run_specs
end

# Ctrl-C
Signal.trap('INT') { abort("\n") }


if __FILE__ == $0
  system("watchr #{$0}")
else
  run_specs

  [
    'lib/(.*/)?.*\.rb',
    'spec/(.*/)?.*_spec\.rb'
  ].each do |pattern|
    watch(pattern) { |md| run_specs }
  end
end
