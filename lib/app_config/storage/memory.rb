module AppConfig
  module Storage
    class Memory < Storage::Base

      # Instantiates a new Storage::Memory.
      #
      # @param data will be saved in an {Hashish}
      # @param options options hash
      #
      # @return [Memory]
      def initialize(data, options)
        super(data, options)
      end

    end # Memory
  end # Storage
end # AppConfig
