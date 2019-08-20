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

  def config_for_mongo(load_test_data = true, drop_collection = true, opts = {})
    mongo = AppConfig::Storage::Mongo::DEFAULTS.merge({
      host: ENV.fetch('MONGO_HOST') { 'mongo_db' },
      database: 'app_config_test',
    })

    begin
      load_mongo_test_config(mongo) if load_test_data
      config_for({mongo: mongo}.merge(opts))

      if drop_collection
        collection = AppConfig.class_variable_get(:@@storage)
          .send(:collection)
          .drop
      end
    rescue Mongo::ConnectionFailure
      skip "***** Mongo specs require a running MongoDB server *****"
    end
  end

  def config_for_mysql(load_test_data = false, opts = {})
    mysql = AppConfig::Storage::MySQL::DEFAULTS.merge({
      host: ENV.fetch('MYSQL_HOST') { 'mysql_db' },
      database: 'app_config_test'
    })

    begin
      load_mysql_test_config(mysql) if load_test_data
      config_for({mysql: mysql}.merge(opts))
    rescue Mysql2::Error => e
      if e.to_s =~ /Can't connect/
        skip "***** MySQL specs require a running MySQL server *****"
      else
        raise e
      end
    end
  end

  def config_for_postgres(load_test_data = false, opts = {})
    postgres = AppConfig::Storage::Postgres::DEFAULTS.merge({
      host: ENV.fetch('POSTGRES_HOST') { 'postgres_db' },
      user: 'postgres',
      dbname: 'app_config_test'
    })

    begin
      load_postgres_test_config(postgres) if load_test_data
      config_for({postgres: postgres}.merge(opts))
    rescue PG::Error => e
      if e.to_s =~ /could not connect to server/
        skip "***** Postgres specs require a running PostgreSQL server *****"
      else
        # Re-raise the exception, since we only care about connectivity here.
        raise e
      end
    end
  end

  def config_for_sqlite(wipe_database = true)
    Dir.mkdir(File.expand_path('tmp')) unless Dir.exists?(File.expand_path('tmp'))

    database = File.expand_path(File.join('tmp', 'app_config_spec.sqlite3'))

    if wipe_database
      File.delete(database) if File.exists?(database)

      db = ::SQLite3::Database.new(database)
      table = AppConfig::Storage::SQLite::DEFAULTS[:table]

      config = ::YAML.load_file(fixture('app_config.yml'))
      attrs = config.map do |k, v|
        if v.class == String
          "#{k} varchar(255)"
        else
          "#{k} INTEGER DEFAULT #{v ? 1 : 0}"
        end
      end.join(', ')

      create_query = "CREATE TABLE #{table} (id INTEGER PRIMARY KEY, #{attrs})"
      insert_query = "INSERT INTO #{table} (#{config.keys.join(', ')}) VALUES (#{config.values.map { |v|
        if v.is_a?(TrueClass) || v.is_a?(FalseClass)
          # Convert to SQLite boolean INT
          v ? '1' : '0'
        else
          "'#{v}'"
        end
      }.join(', ')})"

      db.execute(create_query)
      db.execute(insert_query)
    end

    config_for(sqlite: { database: database })
  end

  private

  def load_mongo_test_config(options)
    connection = ::Mongo::Connection.new(options[:host], options[:port].to_i)
    database   = connection.db(options[:database])
    collection = database.collection(options[:collection])
    test_data  = YAML.load_file(fixture('app_config.yml'))

    data = collection.find_one
    if data
      collection.update({'_id' => data['_id']}, test_data)
    else
      collection.save(test_data)
    end
  end

  def load_mysql_test_config(options)
    original_options = options.dup

    options.delete(:username) if options[:username].nil?
    options.delete(:password) if options[:password].nil?

    table = options.delete(:table)

    begin
      config = ::YAML.load_file(fixture('app_config.yml'))
      attrs = config.map do |k, v|
        if v.is_a?(String)
          "#{k} VARCHAR(255)"
        elsif v.is_a?(TrueClass) || v.is_a?(FalseClass)
          "#{k} BOOLEAN"
        end
      end.join(', ')

      values = config.values.map do |v|
        if v.is_a?(TrueClass) || v.is_a?(FalseClass)
          # Boolean types shouldn't be quoted.
          "#{v}"
        else
          # But VARCHAR types should be.
          "'#{v}'"
        end
      end.join(', ')

      create_query = "CREATE TABLE #{table} (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, #{attrs});"
      insert_query = "INSERT INTO #{table} (#{config.keys.join(', ')}) VALUES (#{values});"

      client = Mysql2::Client.new(options)
      client.query("USE #{options[:database]};")

      begin
        client.query(create_query)
      rescue Mysql2::Error => e
        case e.to_s
        when /Table '#{table}' already exists/
          # no-op
        else
          raise e
        end
      end

      client.query(insert_query)
    rescue Mysql2::Error => e
      case e.to_s
      when /Unknown database/
        Mysql2::Client.new.query("CREATE DATABASE #{options[:database]};")
        load_mysql_test_config(original_options)
      else
        raise e
      end
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
      attrs = config.map do |k, v|
        if v.class == String
          "#{k} character varying(255)"
        else
          "#{k} boolean DEFAULT #{v}"
        end
      end.join(', ')

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
