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

      def reload!
        fetch_data!
      end

      def save!
        data_hash = @data.to_h
        data_hash.delete(:id)

        if @id
          # Update existing row.
          set_attrs = data_hash.map { |k, v| "#{k} = '#{v}'" }.join(', ')
          save_query = "UPDATE #{@table} SET #{set_attrs} WHERE id = #{@id};"
        else
          # Insert a new row.
          if data_hash.empty?
            # Use table defaults.
            save_query = "INSERT INTO #{@table}(id) VALUES(NULL);"
          else
            columns = data_hash.keys.join(', ')
            values = data_hash.map { |_, v| "'#{v}'" }.join(', ')

            save_query = "INSERT INTO #{@table} (#{columns}) VALUES (#{values});"
          end
        end

        @database.execute(save_query)
        @database.changes == 1
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
        @id = @data.id
      end

    end
  end
end
