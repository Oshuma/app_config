require 'spec_helper'

describe AppConfig do

  it 'has a version' do
    AppConfig::VERSION.should_not be_nil
  end

  it 'responds to .setup()' do
    AppConfig.should respond_to(:setup)
  end

  it 'responds to .reset!()' do
    AppConfig.should respond_to(:reset!)
  end

  it 'should have to_hash' do
    config_for_yaml
    AppConfig.to_hash.class.should == Hash
  end

  it 'should reset @@storage' do
    config_for_yaml   # configure first
    AppConfig.reset!  # then reset
    lambda do
      AppConfig[:some_key]
    end.should raise_error(AppConfig::Error::NotSetup)
  end

  it 'Error::NotSetup is raised when calling to_hash()' do
    # First, reset the storage variable.
    AppConfig.send(:class_variable_set, :@@storage, nil)
    lambda do
      AppConfig.to_hash
    end.should raise_error(AppConfig::Error::NotSetup)
  end

end
