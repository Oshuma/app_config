module AppConfig
  module Storage
    class Memory < BaseStorage

      def initialize(options)
        @data = Hashish.new(options)
      end

    end # Memory
  end # Storage
end # AppConfig
