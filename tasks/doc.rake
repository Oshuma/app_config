APP_ROOT = File.join(File.dirname(__FILE__), '..')

desc 'Generate API documentation'
task :doc do
  Rake::Task['doc:api'].invoke
end

namespace :doc do
  task :setup_rdoc do
    @file_list = FileList[ "#{File.join(APP_ROOT, 'README.rdoc')}",
                           "#{APP_ROOT}/lib/**/*.rb" ]
    # Substitute APP_ROOT with a dot.  Makes for a better index in the generated docs.
    @files = @file_list.collect  {|f| f.gsub(/#{APP_ROOT}/, '.')}
    @options = %W[
      --all
      --inline-source
      --line-numbers
      --main README.rdoc
      --op #{File.join(APP_ROOT, 'doc', 'api')}
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
    sh "rm -rf #{File.join(APP_ROOT, 'doc', 'api')}"
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
  sh "rdoc #{options} #{files}"
end
