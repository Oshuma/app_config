require 'spec_helper'

describe Configurable do
  include Configurable

  before :all do
    @obj_id = config.object_id
  end

  it "should be kind of Storage::Base" do
    config.should be_kind_of AppConfig::Storage::Base
  end

  it "should be another object if force" do
    obj_id = config.object_id
    config(:force => true)
    config.object_id.should_not eq obj_id
  end

  it "should be another object if reload" do
    obj_id = config.object_id
    config(:reload => true)
    config.object_id.should_not eq obj_id
  end

  it "should eval block if force or reload is set" do
    config(:force => true) { |config| config[:newkey] = :newvalue }
    config.should include(:newkey)
  end

  it "should eval block if block is given" do
    config { |config| config[:newkey] = :newvalue }
    config.should include(:newkey)
  end

  it "should not eval block if option 'force' is false" do
    config(:force => false) { |config| config[:newkey] = :newvalue }
    config.should_not include(:newkey)
  end

  it "should set a new key value pair" do
    config.should_not include(:newkey)
    config[:newkey] = :newvalue
    config.should include(:newkey)
  end

  it "should be the same object in each access" do
    config.object_id.should eq @obj_id
  end
end
