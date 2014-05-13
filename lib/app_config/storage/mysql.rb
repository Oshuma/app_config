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

      def reload!
        fetch_data!
      end

      def save!
        data_hash = @data.to_h
        data_hash.delete(:id)

        if @id
          # Update existing row.
          set_attrs = data_hash.map do |k, v|
            if v.is_a?(TrueClass) || v.is_a?(FalseClass)
              "#{k} = #{v}"  # Don't quote booleans.
            else
              "#{k} = '#{v}'"
            end
          end.join(', ')
          save_query = "UPDATE #{@table} SET #{set_attrs} WHERE id = #{@id};"
        else
          # Create a new row.
          if data_hash.empty?
            # Use defaults.
            save_query = "INSERT INTO #{@table}(id) VALUES(NULL);"
          else
            columns = data_hash.keys.join(', ')
            values = data_hash.map do |_, v|
              if v.is_a?(TrueClass) || v.is_a?(FalseClass)
                "#{v}"  # Don't quote booleans.
              else
                "'#{v}'"
              end
            end.join(', ')

            save_query = "INSERT INTO #{@table} (#{columns}) VALUES (#{values});"
          end
        end

        @client.query(save_query)
        @client.affected_rows == 1
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
