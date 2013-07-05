module AppConfig
  module Storage
    # OpenStruct wrapper to hold the underlying `Storage` data.
    class ConfigData < OpenStruct

      # Accepts a Hash and passes that along to `OpenStruct.new`.
      def initialize(hash = {})
        super(hash)
      end

      def to_hash
        marshal_dump
      end
      alias_method :to_h, :to_hash

    end
  end
end
