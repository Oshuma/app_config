require 'spec_helper'

describe AppConfig::Storage::Postgres do

  before(:all) do
    AppConfig.reset!
    config_for_postgres
  end

  it 'should have some values' do
    AppConfig.api_key.should_not be_nil
  end

  it 'should update the values' do
    new_api_key = 'SOME_NEW_API_KEY'

    AppConfig.api_key = new_api_key
    AppConfig.api_key.should == new_api_key

    AppConfig.save!.should be_true
  end

end
