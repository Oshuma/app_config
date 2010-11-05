module AppConfig
  module Storage
    class BaseStorage

      attr_reader :data

      def self.load(options)
        new(options).data
      end

    end # BaseStorage
  end # Storage
end # AppConfig
