Gem::Specification.new do |s|
  s.name = %q{app_config}
  s.version = "0.5.1"
  s.authors = ['Dale Campbell']
  s.email = ['oshuma@gmail.com']
  s.date = %q{2010-07-11}
  s.homepage = 'http://oshuma.github.com/app_config'

  s.summary = %q{Quick and easy application configuration.}
  s.description = %q{An easy to use, customizable library to easily store and retrieve application configuration.}
  s.require_paths = ["lib"]
  # s.rubyforge_project = %q{app-config}
  s.rubygems_version = %q{1.3.6}

  s.has_rdoc = true
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]

  s.files = [
    'Rakefile',
    'README',
    'lib/app_config.rb',
    'lib/app_config/base.rb',
    'lib/app_config/error.rb',
    'lib/app_config/storage.rb',
    'lib/app_config/storage/base_storage.rb',
    'lib/app_config/storage/memory.rb',
    'lib/app_config/storage/sqlite.rb',
    'lib/app_config/storage/yaml.rb',
    'lib/core_ext/hashish.rb',
  ]
end
