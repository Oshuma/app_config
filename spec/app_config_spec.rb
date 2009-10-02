require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AppConfig do
  it 'should have a version' do
    AppConfig.to_version.should_not be_nil
  end

  it 'should have to_hash' do
    config_for_yaml
    AppConfig.to_hash.class.should == Hash
    AppConfig.to_hash.each_pair do |key, value|
      AppConfig[key].should == value
    end
  end
end
