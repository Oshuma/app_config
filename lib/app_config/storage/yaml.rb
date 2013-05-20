module AppConfig
  module Storage

    require 'yaml'

    # YAML storage method.
    class YAML < Storage::Base

      DEFAULT_PATH = File.join(Dir.home, '.app_config.yml')

      # Loads `@data` with the YAML file located at `path`.
      # `@data` will be the Hashish that is accessed with `AppConfig[:key]`.
      #
      # Defaults to `Dir.home/.app_config.yml`
      def initialize(path = DEFAULT_PATH)
        # Make sure to use the top-level YAML module here.
        @data = OpenStruct.new(::YAML.load_file(path))
      end

    end # YAML
  end # Storage
end # AppConfig
