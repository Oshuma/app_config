require 'spec'

require File.expand_path(File.dirname(__FILE__) + '/../lib/app_config')

Spec::Runner.configure do |config|
  include AppConfig
end

def config_for(options)
  AppConfig.configure(options)
end

YAML_FIXTURE = File.expand_path(File.dirname(__FILE__) + '/fixtures/app_config.yml')
def config_for_yaml(opts = {})
  path = opts[:path] || YAML_FIXTURE
  @yaml = {
    :storage_method => :yaml,
    :path => path,
  }
  config_for(@yaml.merge(opts))
end

SQLITE_FIXTURE = File.expand_path(File.dirname(__FILE__) + '/fixtres/app_config.sqlite3')
def config_for_sqlite(opts = {})
  path = opts[:path] || SQLITE_FIXTURE
  @sqlite = {
    :storage_method => :sqlite,
    :path => path
  }
  config_for(@sqlite.merge(opts))
end
