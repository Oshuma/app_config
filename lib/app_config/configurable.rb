module AppConfig
  module Configurable
    def config(options={}, &blk)
      @options, @block_given = options, block_given?
      @config = nil if refresh?
      @config ||= AppConfig.setup(options, &blk)
    end
    alias _config config

    private

    def refresh?
      force = Force.new(@options)
      @options.merge!(:force => true) if @block_given && !force.set?
      force.true?
    end
  end
end
