module AppConfig
  module Storage
    class Base
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def to_hash
        Hashish.new(@data.to_hash)
      end

      def to_yaml
        to_hash.to_yaml
      end

      private

      def method_missing(method, *args, &blk)
        to_hash.send(method, *args, &blk)
      end

    end # Base
  end # Storage
end # AppConfig
