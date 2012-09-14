module AppConfig
  module Storage
    class Memory < Storage::Base

      # Instantiates a new Storage::Memory.
      #
      # @param data will be saved in an {Hashish}
      # @param options options hash
      #
      # @return [Memory]
      def initialize(data, options={})
        super(options)
        @data = Hashish.new(data)
      end

      # Get config with _key_.
      #
      # @param key [String, Symbol]
      #
      # @example
      #   mem = Storage::Memory.new({:newkey => "newvalue"})
      #   mem[:newkey] #=> "newvalue
      #
      # @return value which was set.
      def [](key)
        @data[key]
      end

      # Set config _key_ with _value_.
      #
      # @param key [String, Symbol]
      # @param value [String, Symbol]
      #
      # @example
      #   mem = Storage::Memory.new({})
      #   mem[:newkey] = "newvalue"
      #   mem[:newkey] #=> "newvalue
      def []=(key, value)
        @data[key] = value
      end

      # Checks if storage is empty.
      #
      # @example
      #   mem = Storage::Memory.new({})
      #   mem.empty? #=> true
      #   mem[:newkey] = "newvalue"
      #   mem.empty? #=> false
      #
      # @return true if storage doesn't have any item.
      def empty?
        @data.empty?
      end

    end # Memory
  end # Storage
end # AppConfig
