desc 'Run all specs'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = ['--color', '--format progress']
  t.pattern = FileList['spec/**/*_spec.rb']
end
