module ApiStore
  VERSION = '0.0.1'

  def self.to_version
    "#{self.class} v#{VERSION}"
  end
end
