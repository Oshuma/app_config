$LOAD_PATH.unshift File.dirname(__FILE__)

# TODO: Only load deps if needed (no gems unless required).
dependencies = %w{ sqlite3 yaml uri }

begin
  dependencies.each { |lib| require lib }
rescue LoadError
  require 'rubygems'
  dependencies.each { |lib| require lib }
end

# AppConfig stuff.
require 'core_ext/hashish'

module AppConfig
  VERSION = '0.4.0'

  autoload :Base, 'app_config/base'
  autoload :Error, 'app_config/error'
  autoload :Storage, 'app_config/storage'

  # Returns the AppConfig version string.
  def self.to_version
    "#{self.name} v#{VERSION}"
  end

  # Access the configured <tt>key</tt>'s value.
  def self.[](key)
    @@storage[key]
  end

  # Accepts an +options+ hash or a block.
  # See AppConfig::Base for valid storage methods.
  def self.setup(options = {}, &block)
    @@storage = AppConfig::Base.new(options, &block)
  end

  def self.to_hash
    @@storage.to_hash
  end

end # AppConfig
