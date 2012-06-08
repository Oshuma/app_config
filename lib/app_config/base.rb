module AppConfig

  # The Base storage class.
  # Acts as a wrapper for the different storage methods.
  #
  # See each storage method's documentation for their specific options.
  #
  # Valid storage methods:
  # * `:memory` - {AppConfig::Storage::Memory AppConfig::Storage::Memory}
  # * `:mongo` - {AppConfig::Storage::Mongo AppConfig::Storage::Mongo}
  # * `:yaml` - {AppConfig::Storage::YAML AppConfig::Storage::YAML}
  class Base

    # Accepts either a hash of `options` or a block (which overrides any options passed in the hash).
    def initialize(options = {}, &block)
      @options = options

      if @options[:yaml]
        @storage = AppConfig::Storage::YAML.new(@options.delete(:yaml))
      elsif @options[:mongo]
        @storage = AppConfig::Storage::Mongo.new(@options.delete(:mongo))
      else
        @storage = AppConfig::Storage::Memory.new(@options)
      end

      yield @storage if block_given?
    end

    # Access the `key`'s value in storage.
    def [](key)
      if storage.respond_to?(:[])
        storage[key]
      else
        raise AppConfig::Error::MustOverride.new('#[]')
      end
    end

    def []=(key, value)
      if storage.respond_to?(:[]=)
        storage[key] = value
      else
        raise AppConfig::Error::MustOverride.new('#[]=')
      end
    end

    def empty?
      if storage.respond_to?(:empty?)
        storage.empty?
      else
        raise AppConfig::Error::MustOverride.new('#empty?')
      end
    end

    def environment
      (@options[:environment] || @options[:env]) || nil
    end
    alias_method :env, :environment

    # Returns the `@storage` contents, which is what is exposed
    # as the configuration.
    def storage
      environment ? @storage[environment] : @storage
    end

    def to_hash
      storage.to_hash
    end

  end # Base
end # AppConfig
