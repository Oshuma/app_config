module AppConfig
  # This module is created to include it in all classes where you would like to have access to your configuration.
  #
  # You access by _config_ is cached. So if you'd like to have another object, you could do this by passing :force =>
  # true like:
  # @example Creates a new object with :force
  #   config.object_id #=> 123456
  #   config(:force => true).object_id #=> 654321
  module Configurable
    #
    #
    # @param options [Hash]
    #
    # It will be configured by the _options_ hash. _options_ can have the following
    # keys:
    # * *:yaml*: Path to YAML file.
    # * *:mongo*: Options for MongoDB.
    # * *:create*: This will create the specified YAML file. (:yaml has to be included.)
    # * *:save_changes*: Every change in your storage object will be saved in your YAML file. (:yaml has to be included.)
    # * *:force*: Creates a new object.
    # * *:reload*: Creates a new object.
    #
    # @example Creates a new object
    #   config.object_id #=> 123456
    #   config(:force => true).object_id #=> 654321
    #   config(:reload => true).object_id #=> 101010
    #
    # @example Creates a new object and YAML file will be empty
    #   config(:yaml => "path/to/file.yml", :force => true, :save_changes => true)
    #   File.read("path/to/file.yml") #=> "--- {}"
    #
    # @example Usage with block
    #   config(:yaml => "path/to/file.yml") do |config|
    #     config[:key] = "value"
    #   end
    #   config[:key] #=> "value"
    #
    # @example New object with :force is set
    #   config.object_id #=> 123456
    #   config(:force => true)
    #   # New object
    #   config.object_id #=> 654321
    #
    # @example New object with :force is set and block is given
    #   config.object_id #=> 123456
    #   config(:force => true) { |config| config[:key] = "value" }
    #   # New object
    #   config.object_id #=> 654321
    #
    # @example New object with :force isn't set and block is given
    #   config.object_id #=> 123456
    #   config { |config| config[:key] = "value" }
    #   # New object
    #   config.object_id #=> 654321
    #
    # @example Old object with :force is false and block is given
    #   config.object_id #=> 123456
    #   config(:force => false) { |config| config[:key] = "value" }
    #   # No new object
    #   config.object_id #=> 123456
    #
    # @yield configuration
    # @yieldparam config [AppConfig::Storage]
    # @return [AppConfig::Storage] config
    def config(options={})
      @options = options
      @block_given = block_given?
      @config = nil if !@config.nil? && refresh?
      @config ||= AppConfig.setup(@options) do |config|
        config.clear!
        yield config if @block_given
      end
    end
    alias _config config

    private

    # Checks if object has to be a new one.
    #
    # @example :force is set
    #   config(:force => true)
    #   refresh? #=> true
    #
    # @example :force is set and block is given
    #   config(:force => true) { |config| config[:key] = "value" }
    #   refresh? #=> true
    #
    # @example :force isn't set and block is given
    #   config { |config| config[:key] = "value" }
    #   refresh? #=> true
    #
    # @example :force is false and block is given
    #   config(:force => false) { |config| config[:key] = "value" }
    #   refresh? #=> false
    def refresh?
      force = Force.new(@options)
      @options.merge!(:force => true) if @block_given && !force.set?
      return false if force.false?
      force.true?
    end

    # Check if old config object options aren't equals with actual options
    #
    # @note useless
    def options_changed?
      old_options = @config.options
      new_options = @options
      # removes all Force::KEYS
      Force::KEYS.each do |key|
        old_options.delete(key)
        new_options.delete(key)
      end
      old_options != new_options
    rescue NoMethodError
      true
    end
  end
end
