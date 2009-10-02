Gem::Specification.new do |s|
  s.name = %q{app_config}
  s.version = "0.3.1"
  s.authors = ['Dale Campbell']
  s.email = ['oshuma@gmail.com']
  s.date = %q{2009-10-01}
  s.homepage = 'http://oshuma.github.com/app_config'

  s.summary = %q{Quick and easy application configuration.}
  s.description = %q{An easy to use, customizable library to easily store and retrieve application configuration.}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{app-config}
  s.rubygems_version = %q{1.3.3}

  s.has_rdoc = true
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]

  s.files = [
    'Rakefile',
    'README',
    'lib/app_config.rb',
    'lib/app_config/base.rb',
    'lib/app_config/storage.rb',
    'lib/app_config/storage/sqlite.rb',
    'lib/app_config/storage/yaml.rb',
    'lib/core_ext/hashish.rb',
  ]

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency('sqlite3-ruby')
    else
      s.add_dependency('sqlite3-ruby')
    end
  else
    s.add_dependency('sqlite3-ruby')
  end
end
