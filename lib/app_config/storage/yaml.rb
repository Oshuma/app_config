module AppConfig
  module Storage

    require 'yaml'

    # YAML storage method.
    class YAML < Storage::Base

      DEFAULT_PATH = File.expand_path(File.join(ENV['HOME'].to_s, '.app_config.yml'))

      # Loads `@data` with the YAML file located at `path`.
      # `@data` will be the Hashish that is accessed with `AppConfig[:key]`.
      #
      # Defaults to `$HOME/.app_config.yml`
      def initialize(path = DEFAULT_PATH)
        # Make sure to use the top-level YAML module here.
        @data = Hashish.new(::YAML.load_file(path))
      end

      def [](key)
        @data[key]
      end

      def []=(key, value)
        @data[key] = value
      end

      def empty?
        @data.empty?
      end

    end # YAML
  end # Storage
end # AppConfig
