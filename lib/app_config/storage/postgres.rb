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

        set_attrs = data_hash.map { |k, v| "#{k} = '#{v}'" }.join(', ')

        update_query = "UPDATE #{@table} SET #{set_attrs} WHERE id = #{@id}"

        result = @connection.exec(update_query)
        result.result_status == PG::Constants::PGRES_COMMAND_OK
      end

      private

      def fetch_data!
        raise 'Not connected to PostgreSQL' unless connected?

        # TODO: This might not be the best solution here.
        #       It currently uses the newest row, based on a primary key of `id`.
        #       Maybe provide a way to configure what row gets returned.
        fetch_query = "SELECT * FROM #{@table} ORDER BY id DESC LIMIT 1"

        @connection.exec(fetch_query) do |result|
          result.each do |row|
            @data = OpenStruct.new(row)
            @id = @data.id
          end
        end
      end

      def connected?
        @connection && @connection.status == PG::Constants::CONNECTION_OK
      end

      def setup_connection!
        @connection = PG.connect(@options)
      end

    end
  end
end
