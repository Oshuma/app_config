module AppConfig
  module Storage

    # SQLite3 storage method.
    class Sqlite
      attr_accessor :data

      DEFAULTS = {
        :path => File.expand_path(File.join(ENV['HOME'], '.app_config.sqlite3'))
      }

      # Loads @data with the SQLite3 database located at +path+.
      # @data will be the Hashish that is accessed with AppConfig[:key].
      #
      # Defaults to $HOME/.app_config.sqlite3
      def initialize(options)
        path = options[:path] || DEFAULTS[:path]
        @db = SQLite3::Database.open(path)
        @data = Hashish.new
      end
      
      def self.load(path)
        new(path).data
      end
    end # Sqlite

  end # Storage
end # AppConfig
