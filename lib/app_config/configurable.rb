module AppConfig
  module Configurable
    def config(options={}, &blk)
      @options = options
      raise ArgumentError, "Block will be ignored" if block_given? and !force?
      new_config = AppConfig.setup(options, &blk)
      @config = nil if force?
      @config ||= new_config
    end
    alias _config config

    private

    def force?
      [:force, :reload].any? { |o| @options[o] }
    end
  end
end
