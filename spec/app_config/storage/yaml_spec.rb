require 'spec_helper'

describe AppConfig::Storage::YAML do

  it 'should have some values' do
    config = config_for_yaml
    config[:api_key].should_not be_nil
  end

  it 'should raise file not found' do
    lambda do
      config_for_yaml(:yaml => 'not/a/real/file.yml')
    end.should raise_error(Errno::ENOENT)
  end

  it 'should create file if its option is set' do
    file = fixture('does_not_exist.yml')
    config = config_for_yaml(:yaml => file, :create => true)
    File.exist?(file).should be_true
    config[:api_key] = 'api_key'
    AppConfig.should be_setup
    File.delete file
  end

  it "should reset config" do
    config = config_for_yaml
    config.reset!
    config.should be_empty
  end

  it 'saves the new value in memory' do
    config = AppConfig.setup
    config[:new_key] = 'new value'
    config[:new_key].should == 'new value'
  end

  it 'saves the new value in file' do
    config = example_yaml_config(:save_changes => true)
    config[:new_key] = 'new value'
    config2 = config_for_yaml(:yaml => config.path)
    config2[:new_key].should == 'new value'
  end
end
