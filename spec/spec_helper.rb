require 'rspec'
require "#{File.dirname(__FILE__)}/../lib/app_config"

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
    mongo = AppConfig::Storage::Mongo::DEFAULTS.merge({
      :storage_method => :mongo,
      :host => 'localhost',
      :database => 'app_config_spec',
    })
    begin
      config_for(mongo.merge(opts))
      load_mongo_test_config(mongo)
    rescue Mongo::ConnectionFailure
      pending "***** Mongo specs require a running MongoDB server *****"
    end
  end

  private

  def load_mongo_test_config(options)
    connection = ::Mongo::Connection.new(options[:host], options[:port].to_i)
    database   = connection.db(options[:database])
    collection = database.collection(options[:collection])
    test_data = YAML.load_file(fixture('app_config_mongo.yml'))

    data = collection.find_one
    if data
      collection.update({'_id' => data['_id']}, test_data)
    else
      collection.save(test_data)
    end
  end
end
