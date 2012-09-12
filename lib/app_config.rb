require 'core_ext/hashish'

module AppConfig
  VERSION = '2.0.2'

  autoload :Error,        'app_config/error'
  autoload :Storage,      'app_config/storage'
  autoload :Configurable, 'app_config/configurable'
  autoload :Force,        'util/force'

  class << self

    # Accepts an `options` hash or a block.
    # See each storage method's documentation for their specific options.
    #
    # Valid storage methods:
    # * `:memory` - {AppConfig::Storage::Memory AppConfig::Storage::Memory}
    # * `:mongo` - {AppConfig::Storage::Mongo AppConfig::Storage::Mongo}
    # * `:yaml` - {AppConfig::Storage::YAML AppConfig::Storage::YAML}
    def setup(options = {})
      @@options = options

      if @@options[:yaml]
        @@storage = AppConfig::Storage::YAML.new(@@options.delete(:yaml), @@options)
      elsif @@options[:mongo]
        @@storage = AppConfig::Storage::Mongo.new(@@options.delete(:mongo))
      else
        @@storage = AppConfig::Storage::Memory.new(@@options)
      end

      yield @@storage if block_given?

      storage
    end

    # Returns `true` if {AppConfig.setup AppConfig.setup} has been called.
    def setup?
      !!(defined?(@@storage) && !@@storage.empty?)
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
