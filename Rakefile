require 'spec/rake/spectask'

task :default => [:spec]

desc 'Start an irb session with ApiStore loaded'
task :console do
  sh "irb -I ./lib -r 'api_store'"
end

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
