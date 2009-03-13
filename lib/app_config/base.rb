module AppConfig

  # The Base storage class.
  # Acts as a wrapper for the different storage methods.
  #
  # See each storage method's documentation for their specific options.
  class Base

    attr_accessor :storage_method, :path

    DEFAULTS = {
      :storage_method => :yaml,
      :path => File.expand_path(File.join(ENV['HOME'], '.app_config.yml'))
    }

    # Accepts either a hash of +options+ or a block (which overrides
    # any options passed in the hash).
    #
    # Valid storage methods:
    # * :sqlite
    # * :yaml
    def initialize(options = {}, &block)
      DEFAULTS.merge(options).each_pair do |key, value|
        self.send("#{ key }=", value)
      end
      yield self if block_given?
      @storage = initialize_storage
    end

    # Access the <tt>key</tt>'s value in @storage.
    def [](key)
      @storage[key]
    end

  private

    # This decides how to load the data, based on the +storage_method+.
    def initialize_storage
      case storage_method
      when :sqlite
        # TODO: Initialize SQLite3 storage.
      when :yaml
        AppConfig::Storage::Yaml.load(path)
      end
    end

  end # Base

end # AppConfig
