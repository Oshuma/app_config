require 'spec'

require File.expand_path(File.dirname(__FILE__) + '/../lib/app_config')

Spec::Runner.configure do |config|
  include AppConfig
end

FIXTURE = File.expand_path(File.dirname(__FILE__) + '/fixtures/app_config.yml')
def config_for_yaml(opts = {})
  path = opts[:path] || FIXTURE
  @yaml = {
    :storage_method => :yaml,
    :path => path,
  }
  AppConfig.configure(@yaml.merge(opts))
end
