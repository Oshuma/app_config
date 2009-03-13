$LOAD_PATH.unshift File.dirname(__FILE__)

require 'yaml'

require 'core_ext/hashish'

module AppConfig
  VERSION = '0.0.1'

  autoload :Base, 'app_config/base'
  autoload :Yaml, 'app_config/yaml'

  def self.to_version
    "#{self.class} v#{VERSION}"
  end

  # Access the configured <tt>key</tt>'s value.
  def self.[](key)
    error = "Must call '#{self}.configure' to setup storage!"
    raise error if @@storage.nil?
    @@storage[key]
  end

  # Accepts an +options+ hash or pass a block.
  # See AppConfig::Base for valid options.
  def self.configure(options = {}, &block)
    @@storage = AppConfig::Base.new(options, &block)
  end

end
