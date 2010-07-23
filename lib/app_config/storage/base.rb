module AppConfig
  module Storage
    class Base

      attr_reader :data

      def to_hash
        @data.to_hash
      end

      def [](key)
        raise Error::MustOverride.new("[](key)")
      end

      def []=(key, value)
        raise Error::MustOverride.new("[]=(key, value)")
      end

    end # Base
  end # Storage
end # AppConfig
