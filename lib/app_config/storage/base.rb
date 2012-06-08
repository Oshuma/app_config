module AppConfig
  module Storage
    class Base

      attr_reader :data

      def initialize(options)
        @options = options
      end

      def [](key)
        @data[key]
      end

      def []=(key, value)
        @data[key] = value
      end

      def empty?
        @data.empty?
      end

      def to_hash
        @data.to_hash
      end

    end # BaseStorage
  end # Storage
end # AppConfig
