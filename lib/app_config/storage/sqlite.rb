module AppConfig
  module Storage

    # SQLite3 storage method.
    class Sqlite
      attr_accessor :data

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

      # Creates a new Sqlite storage with the given +path+ and returns the data.
      def self.load(path)
        new(path).data
      end

      private

      # Returns a Hashish that looks something like {:column => value}.
      def load_from_database
        query = ["SELECT * FROM sqlite_master",
                 "WHERE type == 'table' AND name == '#{@options[:table]}'",
                 "AND name != 'sqlite_sequence'"].join(' ')
        table = @db.get_first_row(query).last
        get_columns_from(table)
      end

      # Gets the column names for +table+.
      def get_columns_from(table)
        columns = table.split(', ')
        # Trip the first element, since it's the SQL CREATE statement.
        columns = columns[1, columns.size]
        # Yes, Ruby is 'elegant', but this is fucking disgusting.  There *must* be a better way.
        columns.map! {|c| c.split('"').reject {|e| e.empty? }.reject {|e| e.include? '('}}.flatten!
        values_for(columns)
      end

      # Returns a Hashish mapping of the +columns+ and their values.
      def values_for(columns)
        data = Hashish.new
        query = "SELECT #{columns.join(', ')} FROM #{@options[:table]}"
        @db.get_first_row(query).each_with_index do |value, index|
          data[columns[index]] = value
        end
        data
      end
    end # Sqlite

  end # Storage
end # AppConfig
