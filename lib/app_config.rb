require 'core_ext/hashish'

module AppConfig
  VERSION = '1.0.1'

  autoload :Error,   'app_config/error'
  autoload :Storage, 'app_config/storage'

  class << self

    # Accepts an `options` hash or a block.
    # See each storage method's documentation for their specific options.
    #
    # Valid storage methods:
    # * `:memory` - {AppConfig::Storage::Memory AppConfig::Storage::Memory}
    # * `:mongo` - {AppConfig::Storage::Mongo AppConfig::Storage::Mongo}
    # * `:yaml` - {AppConfig::Storage::YAML AppConfig::Storage::YAML}
    def setup(options = {}, &block)
      @@options = options

      if @@options[:yaml]
        @@storage = AppConfig::Storage::YAML.new(@@options.delete(:yaml))
      elsif @@options[:mongo]
        @@storage = AppConfig::Storage::Mongo.new(@@options.delete(:mongo))
      else
        @@storage = AppConfig::Storage::Memory.new(@@options)
      end

      yield @@storage if block_given?

      to_hash
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
      storage[key]
    end

    # Set a new `value` for `key` (persistence depends on the type of Storage).
    def []=(key, value)
      setup unless setup?
      storage[key] = value
    end

    def empty?
      storage.empty?
    end

    def to_hash
      setup? ? storage.to_hash : Hashish.new
    end

    private

    def environment
      (@@options[:environment] || @@options[:env]) || nil
    end
    alias_method :env, :environment

    # Returns the `@@storage` contents, which is what is exposed as the configuration.
    def storage
      environment ? @@storage[environment] : @@storage
    end

  end # self
end # AppConfig
