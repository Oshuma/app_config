class ApiStore
  VERSION = '0.0.1'

  def self.to_version
    "#{self.class} v#{VERSION}"
  end

  attr_accessor :storage_method

  def initialize(opts = {}, &block)
    opts.each_pair { |key, value| self.send("#{key}=", value) }
    yield self if block_given?
    @storage = nil
    initialize_storage
  end

  def self.configure(opts = {}, &block)
    new(opts, &block)
  end

private

  def initialize_storage
    case storage_method
    when :yaml
      # TODO: yaml storage
    end
  end

end
