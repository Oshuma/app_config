module ApiStore

  class Base

    attr_accessor :storage_method, :path

    def initialize(opts = {}, &block)
      opts.each_pair { |key, value| self.send("#{key}=", value) }
      yield self if block_given?
      @storage = initialize_storage
    end

    def [](key)
      @storage[key]
    end

  private

    def initialize_storage
      case storage_method
      when :yaml
        ApiStore::Yaml.load(path)
      end
    end

  end # Base

end # ApiStore
