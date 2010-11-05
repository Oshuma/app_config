module AppConfig
  module Storage

    require 'yaml'

    # YAML storage method.
    class YAML < Storage::Base

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

    end # YAML
  end # Storage
end # AppConfig
