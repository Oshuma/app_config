module AppConfig
  module Storage

    require 'mongo'

    # Mongo storage method.
    class Mongo < Storage::Base

      DEFAULTS = {
        host:       'localhost',
        port:       27017,
        database:   'app_config',
        collection: 'app_config',
        username:   nil,
        password:   nil,
      }

      def initialize(options)
        # Allows passing `true` as an option.
        if options.is_a?(Hash)
          @options = DEFAULTS.merge(options)
        else
          @options = DEFAULTS
        end

        setup_connection!
        fetch_data!
      end

      # Saves the data back to Mongo.  Returns `true`/`false`.
      def save!
        if @_id
          retval = collection.update({ '_id' => @_id}, @data.to_hash)
        else
          retval = collection.save(@data.to_hash)
        end

        !!retval
      end

      private

      def authenticate_connection!
        database.authenticate(@options[:username], @options[:password])
      end

      def connected?
        @connection && @connection.connected?
      end

      def collection
        @collection ||= database.collection(@options[:collection])
      end

      def database
        @database ||= @connection.db(@options[:database])
      end

      def fetch_data!
        raise 'Not connected to MongoDB' unless connected?

        @data = Storage::ConfigData.new(collection.find_one)
        @_id = @data._id
      end

      def setup_connection!
        @connection = ::Mongo::Connection.new(@options[:host], @options[:port].to_i)
        authenticate_connection! if @options[:username] && @options[:password]
      end

    end # Mongo
  end # Storage
end # AppConfig
