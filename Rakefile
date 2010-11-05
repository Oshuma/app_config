require 'spec/rake/spectask'

FileList[File.dirname(__FILE__) + '/tasks/**/*.rake'].each { |task| load task }

task :default => [:spec]

desc 'Start an irb session with AppConfig loaded'
task :console do
  sh "irb -I ./lib -r 'app_config'"
end
