Gem::Specification.new do |s|
  s.name = 'app_config'
  s.version = '0.2.3'
  s.authors = ['Dale Campbell']
  s.email = ['oshuma@gmail.com']
  s.homepage = 'http://oshuma.github.com/app_config'
  s.summary = %q{Quick and easy application configuration.}
  s.description = %q{An easy to use, customizable library to easily store and retrieve application configuration.}
  s.rubygems_version = %q{1.3.5}

  s.rubyforge_project = %q{app-config}

  # s.has_rdoc = true
  # s.rdoc_options << '--title' << 'AppConfig' << '--all' << '--inline-source' << '--line-numbers'

  s.require_paths = ["lib"]
  s.files = Dir[
    "README", "Rakefile",
    "lib/**/*.rb", "spec/**/*",
  ]
end
