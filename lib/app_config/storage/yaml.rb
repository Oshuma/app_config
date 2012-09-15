module AppConfig
  module Storage
    require 'yaml'

    # YAML storage. It can create your file
    #
    # @example Usage with :create and :save_changes
    #   File.exist?("path/to/file.yaml") #=> false
    #   config = Storage::YAML.new("path/to/file.yaml", :create => true, :save_changes => true)
    #   File.exist?("path/to/file.yaml") #=> true
    #   File.read("path/to/file.yaml").empty? #=> true
    #   config[:newkey] = "newvalue"
    #   config[:newkey] #=> "newvalue"
    #   File.read("path/to/file.yaml").empty? #=> false
    #   config.save!
    #
    # @example Usage without :create and :save_changes
    #   File.exist?("path/to/file.yaml") #=> false
    #   # Create directories _path_ and _to_...
    #   # Touch file.yaml
    #   config = Storage::YAML.new("path/to/file.yaml")
    #   File.read("path/to/file.yaml").empty? #=> true
    #   config[:newkey] = "newvalue"
    #   config[:newkey] #=> "newvalue"
    #   File.read("path/to/file.yaml").empty? #=> true
    #   config.save!
    #   File.read("path/to/file.yaml").empty? #=> false
    class YAML < Storage::Base
      # @example
      #   yaml = Storage::YAML.new("path/to/file.yaml", :create => true, :save_changes => true)
      #   yaml.path #=> "path/to/file.yaml"
      attr_reader :path

      DEFAULT_PATH = File.expand_path(File.join(ENV['HOME'], '.app_config.yml'))

      # Loads @data with the YAML file located at `path`.
      # `@data` will be the Hashish that is accessed with `AppConfig[:key]`.
      #
      # Defaults to `$HOME/.app_config.yml`

      # @param path Path to YAML file
      # @param options options hash
      #
      # It will be configured by the _options_ hash. _options_ can have the following
      # keys:
      # * *:create*: This will create the specified YAML file even it doesn't exist.
      #   Each directory and the file will be created.
      # * *:save_changes*: Every change in your storage object will be saved in your YAML file.
      #
      def initialize(path = DEFAULT_PATH, options={})
        super({}, options)
        @path = path
        create_file if @options[:create]
        @data = Hashish.new(load_yaml)
      end

      # Set config _key_ with _value_.
      # Save YAML file if option :save_changes is set.
      #
      # @param key [String, Symbol]
      # @param value [String, Symbol]
      #
      # @example
      #   yaml = Storage.new("path/to/file.yaml")
      #   yaml[:newkey] = "newvalue"
      #   yaml[:newkey] #=> "newvalue
      #
      # @note It could overwrite your YAML file if option :save_changes is set.
      def []=(key, value)
        # @override
        @data[key] = value
        save! if save_changes?
      end

      # Clears data and saves it if option :save_changes is set. This means that your YAML file is empty.
      def clear!
        @data.clear
        save! if save_changes?
      end
      alias :reset! :clear!

      # Checks if option :save_changes is set.
      #
      # @example
      #   yaml = Storage::YAML.new("path/to/file.yaml", :save_changes => true)
      #   yaml.save? #=> true
      #
      # @example
      #   yaml = Storage::YAML.new("path/to/file.yaml")
      #   yaml.save_changes? #=> false
      #
      # @return true if option :save_changes is set.
      def save_changes?
        !!@options[:save_changes]
      end

      # Writes your configuration in file which is located in your specified path.
      #
      # @note It could overwrite your YAML file.
      #
      # @param file [String] Path of file, which will be written.
      def save!(file=@path)
        to_hash.save!(file, :format => :yaml)
      end

      private

      # Creates non-existing directories and the file is empty.
      def create_file
        require 'fileutils'
        dirname = File.dirname(@path)
        FileUtils.mkdir_p dirname
        FileUtils.touch @path
      end

      # Loads content of YAML file.
      # @return hash [Hash]
      def load_yaml
        # Make sure to use the top-level YAML module here.
        ::YAML.load(File.read(@path)) || {}
      end

    end # YAML
  end # Storage
end # AppConfig
