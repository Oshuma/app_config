module AppConfig
  # This storage saves it data in a MongoDB database. You can write and read it.
  module Storage

    require 'mongo'

    # Mongo storage method.
    class Mongo < Storage::Base

      # All default information for access to your database.
      DEFAULTS = {
        :host       => 'localhost',
        :port       => '27017',
        :database   => 'app_config',
        :collection => 'app_config',
        :user       => nil,
        :password   => nil
      }

      # Connects and loads data of your database.
      #
      #
      # @param options options hash
      #   Your can use it to set your username and password and override all default options in _DEFAULTS_.
      #
      # It will be configured by the _options_ hash. _options_ can have the following
      # keys:
      # * *:host*: Host of your running MongoDB instance.
      # * *:port*: Port number of your running MongoDB instance.
      # * *:database*: Name of your database.
      # * *:collection*: Name of your collection.
      # * *:user*: Your username of your running MongoDB instance.
      # * *:password*: Your password of your running MongoDB instance.
      # See {Mongo::DEFAULTS default options}.
      def initialize(options)
        super({}, DEFAULTS.merge(options))
        setup_connection
        fetch_data!
      end

      # {include:Storage::Base#[]=}
      # Writes changes to your database.
      #
      # @param key [String, Symbol]
      # @param value [String, Symbol]
      #
      # @example
      #   mem = Storage::Mongo.new
      #   mem[:newkey] = "newvalue"
      #   mem[:newkey] #=> "newvalue
      #
      # @note It could overwrite your collection in your database.
      def []=(key, value)
        # @override
        super(key, value)
        save!
      end

      private

      def save!
        if @_id
          collection.update({ '_id' => @_id}, @data)
        else
          collection.save(@data)
        end
      end

      def setup_connection
        @connection = ::Mongo::Connection.new(@options[:host], @options[:port].to_i)
        authenticate_connection if @options[:user] && @options[:password]
      end

      def authenticate_connection
        database.authenticate(@options[:user], @options[:password])
      end

      def connected?
        @connection && @connection.connected?
      end

      def fetch_data!
        raise 'Not connected to MongoDB' unless connected?
        @data = Hashish.new(collection.find_one)
        @_id = @data.delete('_id')
      end

      def database
        @database ||= @connection.db(@options[:database])
      end

      def collection
        @collection ||= database.collection(@options[:collection])
      end

    end # Mongo
  end # Storage
end # AppConfig
