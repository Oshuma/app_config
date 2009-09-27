APP_DIR = File.join(File.dirname(__FILE__), '..')
PKG_DIR = File.join(APP_DIR, 'pkg')
GEMSPEC = File.join(APP_DIR, 'app_config.gemspec')

desc 'Build the gem'
task :gem => ['gem:build']

namespace :gem do
  task :build do
    Dir.chdir(PKG_DIR) do
      sh "gem build #{GEMSPEC}"
    end
  end

  desc "Clean the build directory (#{PKG_DIR})"
  task :clean do
    sh "rm -f #{PKG_DIR}/*.gem"
  end

  desc 'Clean, rebuild and install the gem'
  task :install do
    Rake::Task['gem:clean'].invoke
    Rake::Task['gem:build'].invoke
    gem = FileList["#{PKG_DIR}/*.gem"].first
    sh "gem uninstall app_config; gem install #{gem}"
  end
end
