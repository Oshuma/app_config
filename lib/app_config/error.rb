module AppConfig
  module Error

    class MustOverride < Exception
      # Pass in a +method+ name as a symbol or string.
      def initialize(method); @method = method.to_s; end
      def to_s; "Must override method '#{@method}' in a subclass."; end
    end

    class NotSetup < Exception
      def to_s; "Must call 'AppConfig.setup' to configure storage!"; end
    end

    class UnknownStorageMethod < Exception; end

  end # Error
end # AppConfig
