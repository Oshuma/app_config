require 'simplecov'
SimpleCov.start do
  add_filter '/spec'
end

require 'rspec'
require 'app_config'

RSpec.configure do |config|
  include AppConfig

  # Returns the full path to the +name+ fixture file.
  def fixture(name)
    File.expand_path(File.join(File.dirname(__FILE__), 'fixtures', name))
  end

  # AppConfig.setup wrapper.  Accepts a hash of +options+.
  def config_for(options)
    AppConfig.setup(options)
  end

  # Setup YAML options and pass to config_for().
  def config_for_yaml(opts = {})
    path = opts[:yaml] || fixture('app_config.yml')
    config_for({ :yaml => path }.merge(opts))
  end

  def temp_config_file
    require 'tempfile'
    Tempfile.new('config')
  end

  def example_yaml_config(options={})
    options = {:yaml => temp_config_file}.update(options)
    config = AppConfig.setup(options) do |c|
      c[:name] = 'Dale'
      c[:nick] = 'Oshuma'
    end
    config.should be_instance_of(Storage::YAML)
    config[:date] = Date.today
    config
  end

  def check_save_config(yaml, file)
    yaml.should eq File.read(file)
  end

  def config_for_mongo(opts = {}, load_test_data = true)
    mongo = AppConfig::Storage::Mongo::DEFAULTS.merge({
      :host => 'localhost',
      :database => 'app_config_test',
    })
    begin
      load_mongo_test_config(mongo) if load_test_data
      config_for({:mongo => mongo}.merge(opts))
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
