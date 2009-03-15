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
end
