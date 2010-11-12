require 'rubygems' if RUBY_VERSION =~ /^1\.8/
require 'rspec'

require File.expand_path("#{File.dirname(__FILE__)}/../lib/app_config")

RSpec.configure do |config|
  include AppConfig

  # Returns the full path to the +name+ fixture file.
  def fixture(name)
    File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', name))
  end

  # AppConfig.setup wrapper.  Accepts a hash of +options+.
  def config_for(options)
    AppConfig.reset!
    AppConfig.setup(options)
  end

  # Setup YAML options and pass to config_for().
  def config_for_yaml(opts = {})
    path = opts[:path] || fixture('app_config.yml')
    yaml = {
      :storage_method => :yaml,
      :path => path,
    }
    config_for(yaml.merge(opts))
  end

  def config_for_mongo(opts = {})
    mongo = {
      :storage_method => :mongo,
      :host => 'localhost',
      :database => 'app_config_spec',
    }
    begin
      config_for(mongo.merge(opts))
    rescue Mongo::ConnectionFailure
      pending "***** Mongo specs require a running MongoDB server *****"
    end
  end
end
