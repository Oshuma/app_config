require 'spec_helper'

describe AppConfig do

  it 'has a version' do
    AppConfig::VERSION.should_not be_nil
  end

  it 'responds to .setup()' do
    AppConfig.should respond_to(:setup)
  end

  it 'responds to .setup?()' do
    AppConfig.should respond_to(:setup?)
  end

  it 'responds to .reset!()' do
    AppConfig.should respond_to(:reset!)
  end

  it 'should have to_hash' do
    config_for_yaml
    AppConfig.to_hash.class.should == Hashish
  end

  it 'should reset @@storage' do
    # configure first
    config_for_yaml(:api_key => 'API_KEY')
    # then reset
    AppConfig.reset!
    AppConfig[:api_key].should be_nil
  end

  it 'to_hash() returns an empty hash if storage not set' do
    AppConfig.reset!
    AppConfig.to_hash.should == {}
  end

  describe 'environment mode' do
    it 'should load the proper environment' do
      config_for_yaml(:yaml => fixture('env_app_config.yml'),
                      :env  => 'development')
      AppConfig[:api_key].should_not be_nil
    end
  end

  it 'should not be setup' do
    AppConfig.reset!
    AppConfig.should_not be_setup
  end

  it 'should be setup' do
    config_for_yaml
    AppConfig.should be_setup
  end

  it 'should create nested keys' do
    pending 'Implement nested keys'
    AppConfig.reset!
    AppConfig.setup

    AppConfig[:name][:first] = 'Dale'
    AppConfig[:name][:first].should == 'Dale'
  end

  it 'returns a Storage::Memory on setup' do
    AppConfig.reset!
    config = AppConfig.setup do |c|
      c[:name] = 'Dale'
      c[:nick] = 'Oshuma'
    end
    config.should be_instance_of(Storage::Memory)
  end

  it 'saves data as Storage::YAML by AppConfig' do
    AppConfig.reset!
    config = example_yaml_config
    AppConfig.save!
    save_config(config.path)
  end

  it 'saves data as Storage::YAML by Hashish' do
    AppConfig.reset!
    config = example_yaml_config
    config.save!
    save_config(config.path)
  end
end
