require 'spec/rake/spectask'

task :default => [:spec]

desc 'Start an irb session with AppConfig loaded'
task :console do
  sh "irb -I ./lib -r 'app_config'"
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

desc 'Run all specs in spec directory with RCov'
Spec::Rake::SpecTask.new(:rcov) do |t|
  t.spec_opts = ['--options', 'spec/spec.opts']
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.rcov = true
  t.rcov_opts = lambda do
    IO.readlines('spec/rcov.opts').map {|l| l.chomp.split ' '}.flatten
  end
end

desc 'Generate API documentation'
task :doc do
  Rake::Task['doc:api'].invoke
end

namespace :doc do
  task :setup_rdoc do
    @file_list = FileList[ "#{File.dirname(__FILE__)}/README",
                           "#{File.dirname(__FILE__)}/lib/**/*.rb" ]
    # Substitute APP_ROOT with a dot.  Makes for a better index in the generated docs.
    @files = @file_list.collect  {|f| f.gsub(/#{File.dirname(__FILE__)}/, '.')}
    @options = %W[
      --all
      --inline-source
      --line-numbers
      --main README
      --op #{File.join(File.dirname(__FILE__), 'doc', 'api')}
      --title 'AppConfig API Documentation'
    ]
    # Generate a diagram, yes/no?
    @options << '-d' if RUBY_PLATFORM !~ /win32/ && `which dot` =~ /\/dot/ && !ENV['NODOT']
  end

  task :api => [:setup_rdoc] do
    run_rdoc(@options, @files)
  end

  desc 'Remove generated API documentation'
  task :clear do
    system("rm -rf #{File.dirname(__FILE__) + '/doc/api'}")
  end

  desc 'Rebuild API documentation'
  task :rebuild do
    Rake::Task['doc:clear'].invoke
    Rake::Task['doc:api'].invoke
  end
end

private

def run_rdoc(options, files)
  options = options.join(' ') if options.is_a? Array
  files   = files.join(' ')   if files.is_a? Array
  system("rdoc #{options} #{files}")
end
