require 'bundler'
require 'rdoc/task'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

task :default => :spec

desc 'Start an irb session with AppConfig loaded'
task :console do
  sh "irb -I ./lib -r 'app_config'"
end

desc 'Run the specs'
RSpec::Core::RakeTask.new(:spec)

namespace :docs do
  Rake::RDocTask.new do |rd|
    rd.title = "AppConfig API"
    rd.main = "README.rdoc"
    rd.rdoc_dir = "#{File.dirname(__FILE__)}/doc/api"
    rd.rdoc_files.include("README.rdoc", "lib/**/*.rb")
    rd.options << "--all"
  end
end

desc 'Build the API docs'
task :docs do
  Rake::Task['docs:rerdoc'].invoke
  STDOUT.puts "Copying Javascript files..."
  doc_root = "#{File.dirname(__FILE__)}/doc"
  system("cp -r #{doc_root}/js #{doc_root}/api/")
end
