require 'spec'

require File.expand_path(File.dirname(__FILE__) + '/../lib/app_config')

Spec::Runner.configure do |config|
  include AppConfig
end

# Returns the full path to the +name+ fixture file.
def fixture(name)
  File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', name))
end

# AppConfig.configure wrapper.  Accepts a hash of +options+.
def config_for(options)
  AppConfig.setup(options)
end

# Setup Yaml options and pass to config_for().
def config_for_yaml(opts = {})
  path = opts[:path] || fixture('app_config.yml')
  yaml = {
    :storage_method => :yaml,
    :path => path,
  }
  config_for(yaml.merge(opts))
end

# Setup Sqlite options and pass to config_for().
def config_for_sqlite(opts = {})
  path = opts[:path] || fixture('app_config.sqlite3')
  sqlite = {
    :storage_method => :sqlite,
    :path => path
  }
  config_for(sqlite.merge(opts))
end
