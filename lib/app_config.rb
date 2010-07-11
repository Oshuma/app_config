$LOAD_PATH.unshift File.dirname(__FILE__)

# AppConfig stuff.
require 'core_ext/hashish'

module AppConfig
  VERSION = '0.5.1'

  autoload :Base, 'app_config/base'
  autoload :Error, 'app_config/error'
  autoload :Storage, 'app_config/storage'

  class << self
    # Returns the AppConfig version string.
    def to_version
      "#{self.name} v#{VERSION}"
    end

    # Accepts an +options+ hash or a block.
    # See AppConfig::Base for valid storage methods.
    def setup(options = {}, &block)
      @@storage = AppConfig::Base.new(options, &block)
    end

    # Clears the <tt>@@storage</tt> (sets it to nil).
    def reset!
      @@storage = nil
    end

    # Returns the <tt>@@storage</tt> as a Hash-ish object.
    def to_hash
      validate!
      @@storage.to_hash
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

    private

    def validate!
      raise AppConfig::Error::NotSetup unless defined?(@@storage) && @@storage
    end

  end # self
end # AppConfig
