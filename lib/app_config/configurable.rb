module AppConfig
  module Configurable
    def config(options={}, &blk)
      @options = options
      @block_given = block_given?
      @config = nil if !@config.nil? && refresh?
      @config ||= AppConfig.setup(@options, &blk)
    end
    alias _config config

    private

    def refresh?
      force = Force.new(@options)
      @options.merge!(:force => true) if @block_given && !force.set?
      return false if force.false?
      force.true? || options_changed?
    end

    def options_changed?
      old_options = @config.options
      new_options = @options
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
