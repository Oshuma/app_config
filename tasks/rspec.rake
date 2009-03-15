desc 'Run the specs with autotest'
task :autotest do
  ENV['RSPEC'] = 'true'
  sh 'autotest'
end

desc 'Run all specs in spec directory'
Spec::Rake::SpecTask.new(:spec) do |t|
  t.spec_opts = ['--options', 'spec/spec.opts']
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc 'Run all specs in spec directory with RCov'
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_opts = ['--options', 'spec/spec.opts']
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = lambda do
    IO.readlines('spec/rcov.opts').map {|l| l.chomp.split ' '}.flatten
  end
end
