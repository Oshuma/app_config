module AppConfig
  module Storage

    require 'yaml'

    # YAML storage method.
    class YAML < Storage::Base
      attr_reader :path

      DEFAULT_PATH = File.expand_path(File.join(ENV['HOME'], '.app_config.yml'))

      # Loads `@data` with the YAML file located at `path`.
      # `@data` will be the Hashish that is accessed with `AppConfig[:key]`.
      #
      # Defaults to `$HOME/.app_config.yml`
      def initialize(path = DEFAULT_PATH, options={})
        # Make sure to use the top-level YAML module here.
        @path = path
        create_file(path) if options[:creation]
        @save = options[:save_changes]
        @data = Hashish.new(::YAML.load_file(path))
      end

      def []=(key, value)
        @data[key] = value
        save! if save?
      end

      # Clears the `@@storage`.
      def reset!
        @data.clear
      end
      alias :clear! :reset!

      def save?
        !!@save
      end

      def save!(file=@path)
        to_hash.save!(file, :format => :yaml)
      end

      private

      def create_file(path)
        require 'fileutils'
        dirname = File.dirname(path)
        FileUtils.mkdir_p dirname
        FileUtils.touch path
      end

    end # YAML
  end # Storage
end # AppConfig
