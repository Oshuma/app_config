module AppConfig
  module Error

    class NotConfigured < Exception
      def to_s; "Must call 'AppConfig.setup' to setup storage!"; end
    end

    class UnknownStorageMethod < Exception; end

  end # Error
end # AppConfig
