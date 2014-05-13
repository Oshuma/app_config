module AppConfig
  module Storage

    require 'mysql2'

    class MySQL < Storage::Base

      DEFAULTS = {
        host: 'localhost',
        port: 3306,
        database: 'app_config',
        table: 'app_config',
        username: nil,
        password: nil,
      }

      def initialize(options)
        # Allows passing `true` as an option, which uses the defaults.
        if options.is_a?(Hash)
          @options = DEFAULTS.merge(options)
        else
          @options = DEFAULTS
        end

        @table = @options.delete(:table)

        setup_client!
        fetch_data!
      end

      private

      def connected?
        @client && @client.ping
      end

      def fetch_data!
        raise 'Not connected to MySQL' unless connected?

        fetch_query = "SELECT * FROM #{@table} ORDER BY id DESC LIMIT 1;"

        result = @client.query(fetch_query, cast_booleans: true, symbolized_keys: true)
        if result.size == 0
          @data = Storage::ConfigData.new
        else
          result.each do |row|
            @data = Storage::ConfigData.new(row)
            @id = @data.id
          end
        end
      end

      def setup_client!
        @client = Mysql2::Client.new(@options)
      end

    end
  end
end
