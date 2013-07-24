module AppConfig
  module Storage

    require 'pg'

    class Postgres < Storage::Base

      DEFAULTS = {
        host:     'localhost',
        port:     5432,
        dbname:   'app_config',
        table:    'app_config',
        user:     nil,
        password: nil,
      }

      def initialize(options)
        # Allows passing `true` as an option.
        if options.is_a?(Hash)
          @options = DEFAULTS.merge(options)
        else
          @options = DEFAULTS
        end

        # HACK: Remove the `user` and `password` keys if they're nil, since `@options` is passed directly to `PG.connect`.
        @options.delete(:user) if @options[:user].nil?
        @options.delete(:password) if @options[:password].nil?

        @table = @options.delete(:table)

        setup_connection!
        fetch_data!
      end

      # Saves the data to Postgres.  Returns `true`/`false`.
      def save!
        # Build the `SET foo = 'bar', ...` string for the UPDATE query.
        data_hash = @data.to_h
        # Remove the primary key (id) from the SET attributes.
        data_hash.delete(:id)

        if @id  # Updating existing values.
          set_attrs = data_hash.map { |k, v| "#{k} = '#{v}'" }.join(', ')
          save_query = "UPDATE #{@table} SET #{set_attrs} WHERE id = #{@id}"
        else  # Creating a new row.
          if data_hash.empty?
            save_query = "INSERT INTO #{@table} DEFAULT VALUES"
          else
            columns = data_hash.keys.join(', ')
            values = data_hash.map { |_, v| "'#{v}'" }.join(', ')
            save_query = "INSERT INTO #{@table} (#{columns}) VALUES (#{values})"
          end
        end

        result = @connection.exec(save_query)

        if result.result_status == PG::Constants::PGRES_COMMAND_OK
          # Initial write (no rows exist), so we have to set @id.
          if result.cmd_status.split[0] == 'INSERT'
            @connection.exec("SELECT id FROM #{@table}") do |result|
              result.each { |row| @id = row['id'] }
            end

            fetch_data!
          end

          true
        else
          false
        end
      end

      private

      def connected?
        @connection && @connection.status == PG::Constants::CONNECTION_OK
      end

      def fetch_data!
        raise 'Not connected to PostgreSQL' unless connected?

        # TODO: This might not be the best solution here.
        #       It currently uses the newest row, based on a primary key of `id`.
        #       Maybe provide a way to configure what row gets returned.
        fetch_query = "SELECT * FROM #{@table} ORDER BY id DESC LIMIT 1"

        @connection.exec(fetch_query) do |result|
          if result.num_tuples == 0
            @data = Storage::ConfigData.new
          else
            result.each do |row|
              # Convert Postgres booleans into Ruby objects.
              row.each { |k, v| row[k] = true  if v == 't' }
              row.each { |k, v| row[k] = false if v == 'f' }

              @data = Storage::ConfigData.new(row)
              @id = @data.id
            end
          end
        end
      end

      def setup_connection!
        @connection = PG.connect(@options)
      end

    end
  end
end
