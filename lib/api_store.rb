$LOAD_PATH.unshift File.dirname(__FILE__)
require 'api_store/base'

module ApiStore
  VERSION = '0.0.1'

  def self.to_version
    "#{self.class} v#{VERSION}"
  end

  def self.[](key)
    error = "Must call '#{self}.configure' to setup storage!"
    raise error if @storage.nil?
    @storage[key]
  end

  def self.configure(opts = {}, &block)
    ApiStore::Base.new(opts, &block)
  end

end
