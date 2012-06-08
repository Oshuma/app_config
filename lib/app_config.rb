require 'core_ext/hashish'

module AppConfig
  VERSION = '0.7.1'

  autoload :Base,    'app_config/base'
  autoload :Error,   'app_config/error'
  autoload :Storage, 'app_config/storage'

  class << self

    # Accepts an `options` hash or a block.
    # See {AppConfig::Base AppConfig::Base} for valid storage methods.
    def setup(options = {}, &block)
      @@storage = AppConfig::Base.new(options, &block)
    end

    # Returns `true` if {AppConfig.setup AppConfig.setup} has been called.
    def setup?
      !!(defined?(@@storage) && !@@storage.empty?)
    end

    # Clears the `@@storage`.
    def reset!
      if defined?(@@storage)
        remove_class_variable(:@@storage)
        true
      else
        false
      end
    end

    # Access the configured `key`'s value.
    def [](key)
      setup unless setup?
      @@storage[key]
    end

    # Set a new `value` for `key` (persistence depends on the type of Storage).
    def []=(key, value)
      setup unless setup?
      @@storage[key] = value
    end

    def to_hash
      setup? ? @@storage.to_hash : Hashish.new
    end

  end # self
end # AppConfig
