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
        @options = DEFAULTS.merge(options)

        setup_connection!
        fetch_data!
      end

      # Saves the data back to Mongo.  Returns `true`/`false`.
      def save!
        if @_id
          retval = collection.update({ '_id' => @_id}, @data.to_h)
        else
          retval = collection.save(@data.to_h)
        end

        !!retval
      end

      private

      def setup_connection!
        @connection = ::Mongo::Connection.new(@options[:host], @options[:port].to_i)
        authenticate_connection! if @options[:username] && @options[:password]
      end

      def authenticate_connection!
        database.authenticate(@options[:username], @options[:password])
      end

      def connected?
        @connection && @connection.connected?
      end

      def fetch_data!
        raise 'Not connected to MongoDB' unless connected?

        @data = OpenStruct.new(collection.find_one)
        @_id = @data._id
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
