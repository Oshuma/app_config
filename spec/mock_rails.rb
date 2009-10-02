# Simple mock Rails class for testing RailsMode.
class MockRails
  attr_accessor :env

  def initialize
    self.env = ENV['RAILS_ENV'] || 'development'
  end
end
