module AppConfig
  module Storage
    class Base

      def initialize(options)
        @options = options
      end

      def to_hash
        defined?(@data) ? @data.to_hash : Hash.new(&Storage::DEEP_HASH)
      end

    end # Base
  end # Storage
end # AppConfig
