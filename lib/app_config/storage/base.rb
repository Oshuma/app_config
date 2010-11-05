module AppConfig
  module Storage
    class Base

      attr_reader :data

      def self.load(options)
        new(options).data
      end

    end # BaseStorage
  end # Storage
end # AppConfig
