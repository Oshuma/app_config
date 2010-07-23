require 'uri'

module AppConfig
  module Storage

    autoload :Base, 'app_config/storage/base'
    autoload :Mongo, 'app_config/storage/mongo'
    autoload :YAML, 'app_config/storage/yaml'

    DEFAULTS = {
      :storage_method => :memory,
    }

    class << self

      # Acts as a wrapper for setting up the different storage methods.
      #
      # See each storage method's documentation for their specific options.
      #
      # Valid storage methods:
      # * :memory (AppConfig::Storage::Memory)
      # * :mongo (AppConfig::Storage::MongoDB)
      # * :yaml (AppConfig::Storage::YAML)
      #
      # Accepts either a hash of +options+ or a block (which overrides
      # any options passed in the hash).
      def setup(options = {}, &block)
        @@options = DEFAULTS.merge(options)
        yield @@options if block_given?

        determine_storage_method if @@options[:uri]
        @@storage = initialize_storage
      end

      private

      # Sets the storage_method depending on the URI given.
      def determine_storage_method
        uri = URI.parse(@@options.delete(:uri))
        case uri.scheme
        when 'mongo'
          # TODO: Implement this...maybe.
        when 'yaml'
          @@options[:storage_method] = :yaml
          @@options[:path] = uri.path
        end
      end

      # This decides how to load the data, based on the +storage_method+.
      # FIXME: Purge AppConfig-related options before sending to the storage method.
      def initialize_storage
        case @@options[:storage_method]
        when :mongo
          AppConfig::Storage::Mongo.new(@@options)
        when :yaml
          AppConfig::Storage::YAML.new(@@options)
        else
          raise Error::UnknownStorageMethod
        end
      end

    end # self
  end # Storage
end # AppConfig
