require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe AppConfig::Storage::Mongo do

  before(:all) do
    AppConfig.reset!
    config_for_mongo(:api_key => 'SEEKRET_KEY')
  end

  it 'should have some values' do
    AppConfig[:api_key].should_not be_nil
  end

  it 'should update the values' do
    AppConfig.class_variable_get(:@@storage).
      instance_variable_get(:@storage).should_receive(:save!)
    AppConfig[:api_key] = 'SOME_NEW_API_KEY'
    AppConfig[:api_key].should == 'SOME_NEW_API_KEY'
  end
end
