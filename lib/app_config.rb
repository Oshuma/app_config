require 'core_ext/hashish'

module AppConfig
  VERSION = '0.7.1'

  autoload :Base,    'app_config/base'
  autoload :Error,   'app_config/error'
  autoload :Storage, 'app_config/storage'

  class << self

    # Accepts an `options` hash or a block.
    # See {AppConfig::Base AppConfig::Base} for valid storage methods.
    #
    # TODO: Use :yaml, :mongo, etc. keys instead of using :storage_method or :uri.
    def setup(options = {}, &block)
      @@storage = AppConfig::Base.new(options, &block)
    end

    # Returns `true` if {AppConfig.setup AppConfig.setup} has been called.
    def setup?
      defined?(@@storage) && !@@storage.empty?
    end

    # Clears the `@@storage`.
    def reset!
      @@storage = Hashish.new
    end

    # Access the configured `key`'s value.
    def [](key)
      setup unless setup?
      @@storage[key]
    end

    # Set a new `value` for `key` (persistence depends on the type of Storage).
    def []=(key, value)
      @@storage[key] = value
    end

    def to_hash
      @@storage.to_hash
    end

  end # self
end # AppConfig
