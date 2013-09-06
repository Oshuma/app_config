module AppConfig
  module Storage

    require 'yaml'

    # YAML storage method.
    class YAML < Storage::Base

      DEFAULT_PATH = File.join(Dir.home, '.app_config.yml')

      # Loads `@data` with the YAML file located at `path`.
      # `@data` will be the OpenStruct that is accessed with `AppConfig.some_var`.
      #
      # Defaults to `Dir.home/.app_config.yml`
      def initialize(path = DEFAULT_PATH, options = {})
        # Allow passing `true` as an option to use `DEFAULT_PATH`.
        @path = path.is_a?(TrueClass) ? DEFAULT_PATH : path
        @options = options
        reload!
      end

      def reload!
        # Make sure to use the top-level YAML module here.
        if @options.has_key?(:env)
          env = @options[:env].to_s  # Force a String here since YAML's keys are strings.
          @data = Storage::ConfigData.new(::YAML.load_file(@path)[env])
        else
          @data = Storage::ConfigData.new(::YAML.load_file(@path))
        end
      end

    end # YAML
  end # Storage
end # AppConfig
