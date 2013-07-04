$:.push File.expand_path("../lib", __FILE__)
require 'app_config'

Gem::Specification.new do |s|
  s.name = "app_config"
  s.version = AppConfig::VERSION

  s.authors = ['Dale Campbell']
  s.email = ['oshuma@gmail.com']
  s.homepage = 'http://oshuma.github.io/app_config'

  s.summary = %q{Quick and easy application configuration.}
  s.description = %q{An easy to use, customizable library to easily store and retrieve application configuration.}

  s.add_development_dependency 'bson_ext'
  s.add_development_dependency 'mongo'
  s.add_development_dependency 'pg'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'redcarpet'
  s.add_development_dependency 'rspec', '~> 2.10.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'yard'

  s.has_rdoc = true
  s.rdoc_options = ["--inline-source", "--charset=UTF-8"]

  s.require_paths = ["lib"]
  s.files = `git ls-files`.split("\n")

  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
end
