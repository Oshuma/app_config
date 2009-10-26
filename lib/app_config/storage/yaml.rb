module AppConfig
  module Storage

    require 'yaml'

    # YAML storage method.
    class YAML
      attr_reader :data

      DEFAULTS = {
        :path => File.expand_path(File.join(ENV['HOME'], '.app_config.yml'))
      }

      # Loads @data with the YAML file located at +path+.
      # @data will be the Hashish that is accessed with AppConfig[:key].
      #
      # Defaults to $HOME/.app_config.yml
      def initialize(options)
        path = options[:path] || DEFAULTS[:path]
        # Make sure to use the top-level YAML module here.
        @data = Hashish.new(::YAML.load_file(path))
      end

      # Creates a new YAML storage with the given +path+ and returns the data.
      def self.load(path)
        new(path).data
      end

    end # YAML
  end # Storage
end # AppConfig
