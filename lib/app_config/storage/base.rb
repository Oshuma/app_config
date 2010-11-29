module AppConfig
  module Storage
    class Base

      attr_reader :data

      # DEPRECATED
      def self.load(options)
        STDERR.puts("DEPRECATED: AppConfig::Storage::Base.load() has been deprecated")
        new(options).data
      end

      def initialize(options)
        @options = options
      end

    end # BaseStorage
  end # Storage
end # AppConfig
