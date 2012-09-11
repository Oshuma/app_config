module AppConfig
  module Configurable
    def config(options={}, &blk)
      @options = options
      @config = nil if block_given? || force?
      @config ||= AppConfig.setup(options, &blk)
    end
    alias _config config

    private

    def force?
      [:force, :reload].any? { |o| @options[o] }
    end
  end
end
