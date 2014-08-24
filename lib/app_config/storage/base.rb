module AppConfig
  module Storage
    class Base

      def initialize(options = nil)
        @data = Storage::ConfigData.new(options)
      end

      def to_hash
        defined?(@data) ? @data.to_hash : Hash.new
      end

      # Wrap `method_missing` to proxy to `@data`.
      def method_missing(name, *args)
        unless @data.nil?
          if name =~ /.+=$/  # Caller is a setter.
            @data.send(name.to_sym, *args[0])
          else
            @data.send(name.to_sym)
          end
        end
      end

    end # Base
  end # Storage
end # AppConfig
