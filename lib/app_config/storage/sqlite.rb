module AppConfig
  module Storage

    begin
      require 'sqlite3'
    rescue LoadError
      require 'rubygems'
      require 'sqlite3'
    end

    # SQLite3 storage method.
    class Sqlite < BaseStorage

      DEFAULTS = {
        :database => File.expand_path(File.join(ENV['HOME'], '.app_config.sqlite3')),
        :table => 'app_config'
      }

      # Loads @data with the SQLite3 database located at +path+.
      # @data will be the Hashish that is accessed like AppConfig[:key].
      #
      # Defaults to $HOME/.app_config.sqlite3
      def initialize(options)
        @options = DEFAULTS.merge(options)
        @db = SQLite3::Database.open(@options[:database])
        @data = load_from_database
      end

      private

      # Returns a Hashish that looks something like {:column => value}.
      # TODO: This could use a bit of work.
      def load_from_database
        query = ["SELECT * FROM sqlite_master",
                 "WHERE type == 'table' AND name == '#{@options[:table]}'",
                 "AND name != 'sqlite_sequence'"].join(' ')
        table = @db.get_first_row(query).last
        values(columns(table))
      end

      # Return the values for a given +columns+ (as a Hashish).
      def values(columns)
        data = Hashish.new
        query = "SELECT #{columns.join(', ')} FROM #{@options[:table]}"
        @db.get_first_row(query).each_with_index do |value, index|
          data[columns[index]] = value
        end
        data
      end

      # Return the column names of a given +table+ (as an Array).
      def columns(table)
        columns = table.split(', ')
        # Strip the first element, since it's the SQL CREATE statement.
        columns = columns[1, columns.size]
        # Yes, Ruby is 'elegant', but this is fucking disgusting.  There *must* be a better way.
        columns.map! {|c| c.split('"').reject {|e| e.empty? }.reject {|e| e.include? '('}}.flatten!
      end

    end # Sqlite
  end # Storage
end # AppConfig
