module AppConfig
  module Storage

    require 'mongo'

    # Mongo storage method.
    # FIXME: Come up with a way of removing stale config entries.
    class Mongo < Storage::Base

      DEFAULTS = {
        :host       => 'localhost',
        :port       => '27017',
        :database   => 'app_config',
        :collection => 'app_config',
        :user       => nil,
        :password   => nil
      }

      def initialize(options)
        super(DEFAULTS.merge(options))
        @connected = false
        @options = DEFAULTS.merge(options)
        setup_connection
        @data = fetch_data
      end

      def [](key)
        @data[key]
      end

      def []=(key, value)
        @data[key] = value
        save!
      end

      private

      def save!
        if @data.has_key?('_id')
          collection.update({'_id' => @data['_id']}, @data)
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

      def fetch_data
        raise 'Not connected to MongoDB' unless connected?
        Hashish.new(collection.find_one)
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
