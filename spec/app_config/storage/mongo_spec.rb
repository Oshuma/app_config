require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe AppConfig::Storage::Mongo do

  before(:each) do
    AppConfig.reset!
    config_for_mongo
  end

  it 'should save the values' do
    AppConfig[:api_key] = 'SOME_NEW_API_KEY'

    # Reconfigure AppConfig (reloads the data).
    AppConfig.reset!
    config_for_mongo

    AppConfig[:api_key].should == 'SOME_NEW_API_KEY'
  end
end
