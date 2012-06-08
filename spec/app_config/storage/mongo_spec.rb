require 'spec_helper'

# TODO: Drop the Mongo test db before running specs.
describe AppConfig::Storage::Mongo do

  before(:all) do
    AppConfig.reset!
    config_for_mongo
  end

  it 'should have some values' do
    AppConfig[:api_key].should_not be_nil
  end

  it 'should update the values' do
    pending 'Needs a little work...'
    AppConfig.class_variable_get(:@@storage).
      instance_variable_get(:@storage).should_receive(:save!)
    AppConfig[:api_key] = 'SOME_NEW_API_KEY'

    # now reload the config options and check the value
    AppConfig.reset!
    config_for_mongo({}, false)  # use default options and do not load test data
    AppConfig[:api_key].should == 'SOME_NEW_API_KEY'
  end
end
