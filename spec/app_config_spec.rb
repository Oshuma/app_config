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

  it 'should have to_hash' do
    config = config_for_yaml
    config.to_hash.class.should == Hashish
  end

  it 'should reset @@storage' do
    # configure first
    config = config_for_yaml(:api_key => 'API_KEY')
    # then reset
    config.reset!
    config[:api_key].should be_nil
  end

  it 'to_hash() returns an empty hash if storage not set' do
    config = config_for_yaml
    config.reset!
    config.to_hash.should == {}
  end

  describe 'environment mode' do
    it 'should load the proper environment' do
      config = config_for_yaml(:yaml => fixture('env_app_config.yml'),
                      :env  => 'development')
      config[:api_key].should_not be_nil
    end
  end

  it 'should not be setup' do
    config = config_for_yaml
    config.reset!
    AppConfig.should_not be_setup
  end

  it 'should be setup' do
    config_for_yaml
    AppConfig.should be_setup
  end

  it 'should create nested keys' do
    pending 'Implement nested keys'
    config = AppConfig.setup

    config[:name][:first] = 'Dale'
    config[:name][:first].should == 'Dale'
  end

  it 'returns a Storage::Memory on setup' do
    config = AppConfig.setup do |c|
      c[:name] = 'Dale'
      c[:nick] = 'Oshuma'
    end
    config.should be_instance_of(Storage::Memory)
  end

  it 'saves data as Storage::YAML by Hashish' do
    config = example_yaml_config
    config.save!
    check_save_config(config.to_yaml, config.path)
  end

  it 'should be able to access values by methods' do
    config = AppConfig.setup do |c|
      c[:key]  = 'value'
      c[:four] = 20
      c[:name] = 'Dale'
    end

    config.four.should       == 20
    config._four.should      == 20

    config.name.should       == 'Dale'
    config._name.should      == 'Dale'

    # Hash#key(value) is already defined (see Hashish#method_missing)
    expect { config.key }.to raise_error(ArgumentError)
    config._key.should       == 'value'
  end
end
