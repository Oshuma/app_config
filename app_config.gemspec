Gem::Specification.new do |s|
  s.name = 'app_config'
  s.version = '0.1.0'
  s.authors = ['Dale Campbell']
  s.email = ['dale@save-state.net']
  s.homepage = 'http://oshuma.github.com/app_config'
  s.summary = %q{Quick and easy application configuration.}
  s.description = %q{An easy to use, customizable library to easily store and retrieve application configuration}
  s.rubygems_version = %q{1.3.1}

  # s.rubyforge_project = %q{app_config}

  s.require_paths = ["lib"]
  s.files = Dir[
    "README", "Rakefile",
    "lib/**/*.rb", "spec/**/*",
  ]
end
