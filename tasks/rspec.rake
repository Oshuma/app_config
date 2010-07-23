desc 'Run all specs in spec directory'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--colour', '--format progress', '--loadby mtime', '--reverse' ]
  t.spec_files = FileList['spec/**/*_spec.rb']
end
