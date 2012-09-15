module AppConfig
  module Storage
    # This class is the base class for all other storages.
    class Base
      # @attr Hash options hash
      attr_reader :options

      def initialize(data, options={})
        @data = Hashish.new(data)
        @options = options
      end

      # Converts data to hash.
      #
      # @return [Hashish] hash
      def to_hash
        Hashish.new(@data.to_hash)
      end

      # Converts data to YAML.
      #
      # @return [::YAML] yaml
      def to_yaml
        to_hash.to_yaml
      end

      private

      # Each method will be sent to {Hashish} object.
      def method_missing(method, *args, &blk)
        @data.send(method, *args, &blk)
      end

    end # Base
  end # Storage
end # AppConfig
