require 'rake'

require "#{File.dirname(__FILE__)}/lib/app_config"

Gem::Specification.new do |s|
  s.name = %q{app_config}
  s.version = AppConfig::VERSION
  s.date = %q{2010-11-05}

  s.authors = ['Dale Campbell']
  s.email = ['oshuma@gmail.com']
  s.homepage = 'http://oshuma.github.com/app_config'

  s.summary = %q{Quick and easy application configuration.}
  s.description = %q{An easy to use, customizable library to easily store and retrieve application configuration.}

  s.has_rdoc = true
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]

  s.add_dependency('sqlite3-ruby', '>= 1.3.1')
  s.add_development_dependency('rspec', '>= 2.0.1')

  s.require_paths = ["lib"]
  s.files = FileList[
    'README',
    'Rakefile',
    'lib/**/*',
    'spec/**/*',
    'tasks/**/*'
  ].to_a
end
