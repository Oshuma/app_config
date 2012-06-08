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

task :doc => [ 'doc:clean', 'doc:api' ]

namespace :doc do
  require 'yard'
  YARD::Rake::YardocTask.new(:api) do |t|
    t.files = ['lib/**/*.rb']
    t.options = [
      '--output-dir', 'doc/api',
      '--markup', 'markdown'
    ]
  end

  desc 'Remove YARD Documentation'
  task :clean do
    system("rm -rf #{File.dirname(__FILE__)}/doc/api")
  end
end
