module AppConfig

  # The Base storage class.
  # Acts as a wrapper for the different storage methods.
  #
  # See each storage method's documentation for their specific options.
  class Base

    DEFAULTS = {
      :storage_method => :yaml
    }

    # Accepts either a hash of +options+ or a block (which overrides
    # any options passed in the hash).
    #
    # Valid storage methods:
    # * :sqlite
    # * :yaml
    def initialize(options = {}, &block)
      @options = DEFAULTS.merge(options)
      yield @options if block_given?
      @storage = initialize_storage
    end

    # Access the <tt>key</tt>'s value in @storage.
    def [](key)
      @storage[key]
    end

  private

    # This decides how to load the data, based on the +storage_method+.
    def initialize_storage
      case @options[:storage_method]
      when :sqlite
        AppConfig::Storage::Sqlite.load(@options)
      when :yaml
        AppConfig::Storage::Yaml.load(@options)
      else
        raise UnknownStorageMethod
      end
    end

  end # Base

end # AppConfig
