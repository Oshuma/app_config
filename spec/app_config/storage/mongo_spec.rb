require 'spec_helper'

# TODO: Drop the Mongo test db before running specs.
describe AppConfig::Storage::Mongo do

  before(:all) do
    config = config_for_mongo
  end

  it 'should have some values' do
    config[:api_key].should_not be_nil
  end

  it 'should update the values' do
    config.should_receive(:save!)
    config[:api_key] = 'SOME_NEW_API_KEY'
    config[:api_key].should == 'SOME_NEW_API_KEY'
  end

  it 'should not have the Mongo _id in storage' do
    config['_id'].should be_nil
  end

  it 'should have a @_id variable for the Mongo ID' do
    config.instance_variable_get(:@_id).should_not be_nil
  end
end
