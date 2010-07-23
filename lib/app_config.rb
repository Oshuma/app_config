$LOAD_PATH.unshift File.dirname(__FILE__)

require 'core_ext/hashish'

require 'app_config/storage'

module AppConfig
  VERSION = '1.0.0'

  autoload :Error, 'app_config/error'

  class << self

    # Proxy the storage setup to AppConfig::Storage.
    def setup(*args, &block)
      @@storage = Storage.setup(*args, &block)
    end

    def reset!
      @@storage = nil
    end

    # Access the configured <tt>key</tt>'s value.
    def [](key)
      validate!
      @@storage[key]
    end

    # Set a new <tt>value</tt> for <tt>key</tt>.
    def []=(key, value)
      validate!
      @@storage[key] = value
    end

    def to_hash
      validate!
      @@storage.to_hash
    end

    private

    def validate!
      raise AppConfig::Error::NotSetup unless defined?(@@storage) && @@storage
    end

  end # self
end # AppConfig
