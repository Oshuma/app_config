module AppConfig

  # The Base storage class.
  # Acts as a wrapper for the different storage methods.
  #
  # See each storage method's documentation for their specific options.
  class Base

    DEFAULTS = {
      :storage_method => :yaml,
      :uri => nil
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
      determine_storage_method if @options[:uri]
      @storage = initialize_storage
    end

    # Access the <tt>key</tt>'s value in @storage.
    def [](key)
      @storage[key]
    end

  private

    # Sets the storage_method depending on the URI given.
    def determine_storage_method
      uri = URI.parse(@options[:uri])
      case uri.scheme
      when 'sqlite':
        @options[:storage_method] = :sqlite
        @options[:database] = uri.path
      when 'yaml': :yaml
        @options[:storage_method] = :yaml
        @options[:path] = uri.path
      end
    end

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
