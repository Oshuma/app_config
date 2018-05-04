version = File.read(File.expand_path("APP_CONFIG_VERSION", __dir__)).strip

Gem::Specification.new do |s|
  s.name = "app_config"
  s.version = version

  s.authors = ['Dale Campbell']
  s.email = ['oshuma@gmail.com']
  s.homepage = 'http://oshuma.github.io/app_config'

  s.license = 'MIT'

  s.summary = %q{Quick and easy application configuration.}
  s.description = %q{An easy to use, framework agnostic, customizable library to easily store and retrieve application configuration.}

  s.add_development_dependency 'bson', '~> 1.12.5'
  s.add_development_dependency 'bson_ext', '~> 1.12.5'
  s.add_development_dependency 'mongo', '~> 1.12.5'
  s.add_development_dependency 'mysql2', '~> 0.5.1'
  s.add_development_dependency 'pg', '~> 1.0'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'yard', '~> 0.9.12'

  s.has_rdoc = true
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]

  s.require_paths = ["lib"]
  s.files = Dir['lib/**/*']

  s.test_files = Dir['lib/**/*']
end
