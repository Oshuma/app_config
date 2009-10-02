require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AppConfig do
  it 'should have a version' do
    AppConfig.to_version.should_not be_nil
  end

  it 'should act like a normal Hash' do
    AppConfig[:not_a_key].should be_nil
  end

  it 'should have to_hash' do
    config_for_yaml
    AppConfig.to_hash.class.should == Hash
    AppConfig.to_hash.each_pair do |key, value|
      AppConfig[key].should == value
    end
  end

  describe 'environment mode' do
    it 'should load the proper environment' do
      config_for_yaml(:path => fixture('env_app_config.yml'),
                      :env  => 'development')
      AppConfig[:api_key].should_not be_nil
    end
  end
end
