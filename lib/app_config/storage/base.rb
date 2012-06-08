module AppConfig
  module Storage
    class Base

      def initialize(options)
        @options = options
      end

      def to_hash
        @data.to_hash
      end

    end # Base
  end # Storage
end # AppConfig
