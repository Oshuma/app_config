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

  # AppConfig.setup! wrapper.  Accepts a hash of +options+.
  def config_for(options)
    AppConfig.reset!
    AppConfig.setup!(options)
  end

  # Setup YAML options and pass to config_for().
  def config_for_yaml(opts = {})
    path = opts[:yaml] || fixture('app_config.yml')
    config_for({ yaml: path }.merge(opts))
  end

  def config_for_mongo(opts = {}, load_test_data = true)
    mongo = AppConfig::Storage::Mongo::DEFAULTS.merge({
      database: 'app_config_test',
    })
    begin
      load_mongo_test_config(mongo) if load_test_data
      config_for({mongo: mongo}.merge(opts))
    rescue Mongo::ConnectionFailure
      pending "***** Mongo specs require a running MongoDB server *****"
    end
  end

  def config_for_postgres(opts = {}, load_test_data = true)
    postgres = AppConfig::Storage::Postgres::DEFAULTS.merge({
      dbname: 'app_config_test'
    })

    begin
      load_postgres_test_config(postgres) if load_test_data
      config_for({postgres: postgres}.merge(opts))
    rescue PG::Error => e
      if e.to_s =~ /could not connect to server/
        pending "***** Postgres specs require a running PostgreSQL server *****"
      else
        # Re-raise the exception, since we only care about connectivity here.
        raise e
      end
    end
  end

  private

  def load_mongo_test_config(options)
    connection = ::Mongo::Connection.new(options[:host], options[:port].to_i)
    database   = connection.db(options[:database])
    collection = database.collection(options[:collection])
    test_data = YAML.load_file(fixture('app_config.yml'))

    data = collection.find_one
    if data
      collection.update({'_id' => data['_id']}, test_data)
    else
      collection.save(test_data)
    end
  end

  def load_postgres_test_config(options)
    original_options = options.dup

    options.delete(:user) if options[:user].nil?
    options.delete(:password) if options[:password].nil?

    table = options.delete(:table)

    begin
      connection = ::PG.connect(options)

      config = ::YAML.load_file(fixture('app_config.yml'))
      attrs = config.keys.map { |k| "#{k} character varying(255)" }.join(', ')

      create_query = "CREATE TABLE #{table} (id bigserial primary key, #{attrs})"
      insert_query = "INSERT INTO #{table} (#{config.keys.join(', ')}) VALUES (#{config.values.map { |v| "'#{v}'" }.join(', ')})"

      connection.exec(create_query)
      connection.exec(insert_query)
    rescue PG::Error => e
      case e.to_s
      when /database "#{options[:dbname]}" does not exist/
        %x[createdb -U `whoami` -O `whoami` #{options[:dbname]}]
        load_postgres_test_config(original_options)
      when /relation "#{table}" already exists/
        # no-op
      else
        raise e
      end
    end
  end

end
