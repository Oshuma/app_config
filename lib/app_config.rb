require 'ostruct'

module AppConfig
  autoload :VERSION, 'app_config/version'

  autoload :Error,   'app_config/error'
  autoload :Storage, 'app_config/storage'

  class << self

    # Accepts an `options` hash or a block.
    # See each storage method's documentation for their specific options.
    #
    # Valid storage methods:
    # * `:mongo` - {AppConfig::Storage::Mongo AppConfig::Storage::Mongo}
    # * `:yaml` - {AppConfig::Storage::YAML AppConfig::Storage::YAML}
    def setup(options = {}, &block)
      @@options = options

      if @@options[:yaml]
        @@storage = AppConfig::Storage::YAML.new(@@options.delete(:yaml))
      elsif @@options[:mongo]
        @@storage = AppConfig::Storage::Mongo.new(@@options.delete(:mongo))
      else
        @@storage = AppConfig::Storage::Base.new
      end

      yield @@storage if block_given?

      to_hash
    end

    # Returns `true` if {AppConfig.setup AppConfig.setup} has been called.
    def setup?
      defined?(@@storage) && !@@storage.nil?
    end

    # Clears the `@@storage`.
    def reset!
      @@storage = nil
    end

    def to_hash
      storage ? storage.to_hash : {}
    end

    # Wrap `method_missing` to proxy to `storage`.
    def method_missing(name, *args)
      storage.send(name.to_sym, args)
    end

    private

    # Returns the `@@storage` contents, which is what is exposed as the configuration.
    def storage
      @@storage
    end

  end # self
end # AppConfig
