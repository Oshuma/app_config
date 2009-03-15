module AppConfig
  module Storage

    # YAML storage method.
    class Yaml
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
        @data = Hashish.new(YAML.load_file(path))
      end

      # Creates a new Yaml storage with the given +path+ and returns the data.
      def self.load(path)
        new(path).data
      end

    end # Yaml

  end # Storage
end # AppConfig
