module AppConfig
  module Error

    class MustOverride < Exception
      def initialize(method)
        super("Must override method: #{method}")
      end
    end

    class NotSetup < Exception
      def to_s; "Must call 'AppConfig.setup' to setup storage!"; end
    end

    class UnknownStorageMethod < Exception; end

  end # Error
end # AppConfig
