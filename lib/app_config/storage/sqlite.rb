module AppConfig
  module Storage

    require 'sqlite3'

    # SQLite storage method.
    class SQLite < Storage::Base

      DEFAULTS = {
        database: File.join(Dir.home, '.app_config.sqlite3'),
        table: 'app_config',
      }

      def initialize(options)
        # Allows passing `true` as an option to just use defaults.
        if options.is_a?(Hash)
          @options = DEFAULTS.merge(options)
        else
          @options = DEFAULTS
        end

        @database = ::SQLite3::Database.new(@options[:database])
        @table = @options[:table]

        fetch_data!
      end

      private

      def fetch_data!
        config = {}

        # Get the column names in same order as schema.
        columns = []
        table_info = "PRAGMA table_info('#{@table}')"
        @database.execute(table_info) do |row|
          columns << row[1]
        end

        # Get the values in order of columns.
        fetch_query = "SELECT #{columns.join(', ')} FROM #{@table} ORDER BY id DESC LIMIT 1"
        @database.execute(fetch_query) do |row|
          columns.each_with_index do |attr, i|
            config[attr.to_sym] = row[i]
          end
        end

        @data = Storage::ConfigData.new(config)
      end

    end
  end
end
