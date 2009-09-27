$LOAD_PATH.unshift File.dirname(__FILE__)

# TODO: Only load deps if needed (no gems unless required).
libs = %w{ sqlite3 yaml uri }

begin
  libs.each { |lib| require lib }
rescue LoadError
  require 'rubygems'
  libs.each { |lib| require lib }
end

require 'core_ext/hashish'

# TODO: Move these to their own file.
class NotConfigured < Exception
  def to_s; "Must call 'AppConfig.setup' to setup storage!"; end
end
class UnknownStorageMethod < Exception; end

module AppConfig
  VERSION = '0.2.3'

  autoload :Base, 'app_config/base'
  autoload :Storage, 'app_config/storage'

  # Returns the AppConfig version string.
  def self.to_version
    "#{self.class} v#{VERSION}"
  end

  # Access the configured <tt>key</tt>'s value.
  def self.[](key)
    raise NotConfigured unless defined?(@@storage)
    @@storage[key]
  end

  # Accepts an +options+ hash or a block.
  # See AppConfig::Base for valid storage methods.
  def self.setup(options = {}, &block)
    @@storage = AppConfig::Base.new(options, &block)
  end

end
