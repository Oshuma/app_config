require 'core_ext/hashish'

# @example Usage
#   config = AppConfig.setup do |config|
#     config[:key] = "value"
#     config[:newkey] = "newvalue"
#   end
#   config[:tmp] = "/tmp"
#   config[:newkey] #=> "newvalue"
#   config.tmp #=> "/tmp"
#
#   config.key # raises ArgumentError, because Hash#key needs an argument.
#   # But you can use:
#   config._key #=> "value"
module AppConfig
  # Version of this Gem.
  VERSION = '2.0.2'

  autoload :Error,        'app_config/error'
  autoload :Storage,      'app_config/storage'
  autoload :Configurable, 'app_config/configurable'
  autoload :Force,        'util/force'

  class << self

    # Accepts an _options_ hash or a block.
    # See each storage method's documentation for their specific options.
    #
    # Valid storage methods:
    # * *:memory* - {AppConfig::Storage::Memory AppConfig::Storage::Memory}
    # * *:mongo* - {AppConfig::Storage::Mongo AppConfig::Storage::Mongo}
    # * *:yaml* - {AppConfig::Storage::YAML AppConfig::Storage::YAML}
    #
    # @param options [Hash]
    #
    # It will be configured by the _options_ hash. _options_ can have the following
    # keys:
    # * *:yaml*: Path to YAML file.
    # * *:mongo*: Options for MongoDB database.
    # * *:create*: This will create the specified YAML file. (:yaml has to be included.)
    # * *:save_changes*: Every change in your storage object will be saved in your YAML file. (:yaml has to be included.)
    #
    # @yieldparam [Storage] config
    #
    # @note Your yielded block will be returned.
    #
    # @example Initialization without
    #   config = AppConfig.setup
    #   config.class #=> AppConfig::Storage::Memory
    #
    # @example Initialization with :yaml
    #   config = AppConfig.setup(:yaml => "/path/to/file.yml")
    #   config.class #=> AppConfig::Storage::YAML
    #
    # @example Initialization with :mongo
    #   config = AppConfig.setup(:mongo => ??)
    #   config.class #=> AppConfig::Storage::Mongo
    #
    # @return [Storage] config
    def setup(options = {})
      @options = options

      if @options[:yaml]
        @storage = AppConfig::Storage::YAML.new(@options.delete(:yaml), @options)
      elsif @options[:mongo]
        @storage = AppConfig::Storage::Mongo.new(@options.delete(:mongo))
      else
        @storage = AppConfig::Storage::Memory.new({}, @options)
      end

      yield storage if block_given?

      storage
    end

    # @return true if {AppConfig.setup AppConfig.setup} has been called.
    def setup?
      !!(defined?(@storage) && !@storage.empty?)
    end

    private

    def environment
      (@options[:environment] || @options[:env]) || nil
    end
    alias_method :env, :environment

    # @return the `@storage` contents, which is what is exposed as the configuration.
    def storage
      environment ? @storage[environment] : @storage
    end

  end # self
end # AppConfig
