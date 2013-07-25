require 'spec_helper'

describe AppConfig::Storage::Mongo do

  before(:all) do
    AppConfig.reset!
    config_for_mongo
  end

  it 'should have some values' do
    AppConfig.api_key.should_not be_nil
  end

  it 'should update the values' do
    AppConfig.api_key = 'SOME_NEW_API_KEY'
    AppConfig.api_key.should == 'SOME_NEW_API_KEY'

    AppConfig.save!.should be_true
  end

  it 'should have a @_id variable for the Mongo ID' do
    AppConfig.class_variable_get(:@@storage)
      .instance_variable_get(:@_id).should_not be_nil
  end

  it "uses the defaults when 'true' is passed" do
    AppConfig.reset!
    AppConfig.setup!(mongo: true)

    AppConfig.class_variable_get(:@@storage)
      .instance_variable_get(:@options)
      .should == AppConfig::Storage::Mongo::DEFAULTS
  end

  it 'should reload the data' do
    AppConfig.reset!
    config_for_mongo(true, false)

    # Set a variable, but do not call AppConfig.save!
    AppConfig.true_option = false

    AppConfig.reload!

    AppConfig.true_option.should == true
  end

end
