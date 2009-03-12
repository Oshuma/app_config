require 'spec'

require File.expand_path(File.dirname(__FILE__) + '/../lib/api_store')

Spec::Runner.configure do |config|
  include ApiStore
end

FIXTURE = File.expand_path(File.dirname(__FILE__) + '/fixtures/api_store.yml')
def config_for_yaml(opts = {})
  path = opts[:path] || FIXTURE
  @yaml = {
    :storage_method => :yaml,
    :path => path,
  }
  ApiStore.configure(@yaml.merge(opts))
end
