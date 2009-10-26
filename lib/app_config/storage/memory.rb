module AppConfig
  module Storage

    class Memory
      attr_reader :data

      def initialize(options)
        @data = Hashish.new(options)
      end

      def self.load(options)
        new(options).data
      end

    end # Memory
  end # Storage
end # AppConfig
