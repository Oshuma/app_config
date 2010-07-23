require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe AppConfig::Storage::Mongo do
  it 'connects to the MongoDB host' do
    pending "TODO: Spec this out"
  end

  it 'authenticates with MongoDB' do
    pending "TODO: Spec this out"
  end

  it 'should have some values' do
    config_for_mongo
    AppConfig[:api_key].should_not be_nil
  end

  it 'should update the values' do
    config_for_mongo
    original_key = AppConfig[:api_key]
    AppConfig[:api_key] = 'SOME_NEW_API_KEY'

    # Reload the data.
    AppConfig.reset!
    config_for_mongo

    AppConfig[:api_key].should == 'SOME_NEW_API_KEY'
  end
end
