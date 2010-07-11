$LOAD_PATH.unshift File.dirname(__FILE__)

# AppConfig stuff.
require 'core_ext/hashish'

module AppConfig
  VERSION = '0.5.0'

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

    # Access the configured <tt>key</tt>'s value.
    def [](key)
      raise AppConfig::Error::NotSetup unless @@storage
      @@storage[key]
    end

    def to_hash
      raise AppConfig::Error::NotSetup unless @@storage
      @@storage.to_hash
    end

  end # self
end # AppConfig
