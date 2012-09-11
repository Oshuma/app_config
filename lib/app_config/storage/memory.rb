module AppConfig
  module Storage
    class Memory < Storage::Base

      def initialize(options)
        super(options)
        @data = Hashish.new(options)
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

    end # Memory
  end # Storage
end # AppConfig
