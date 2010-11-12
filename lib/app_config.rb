$LOAD_PATH.unshift File.dirname(__FILE__)

# AppConfig stuff.
require 'core_ext/hashish'

module AppConfig
  VERSION = '0.6.0'

  autoload :Base, 'app_config/base'
  autoload :Error, 'app_config/error'
  autoload :Storage, 'app_config/storage'

  class << self

    # Accepts an +options+ hash or a block.
    # See AppConfig::Base for valid storage methods.
    def setup(options = {}, &block)
      @@storage = AppConfig::Base.new(options, &block)
    end

    # Returns +true+ if +AppConfig.setup()+ has been called.
    def setup?
      defined?(@@storage) && @@storage
    end

    # Clears the <tt>@@storage</tt>.
    def reset!
      @@storage = nil if defined?(@@storage)
    end

    # Access the configured <tt>key</tt>'s value.
    def [](key)
      validate!
      @@storage[key]
    end

    # Set a new <tt>value</tt> for <tt>key</tt> (persistence depends on the type of Storage).
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
      raise AppConfig::Error::NotSetup unless setup?
    end

  end # self
end # AppConfig
