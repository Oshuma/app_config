require 'spec_helper'

describe AppConfig::Storage::Mongo do

  before(:all) do
    AppConfig.reset!
    config_for_mongo
  end

  it 'should have some values' do
    expect(AppConfig.api_key).not_to eq(nil)
  end

  it 'should update the values' do
    AppConfig.api_key = 'SOME_NEW_API_KEY'
    expect(AppConfig.api_key).to eq('SOME_NEW_API_KEY')

    expect(AppConfig.save!).to eq(true)
  end

  it 'should have a @_id variable for the Mongo ID' do
    expect(AppConfig.class_variable_get(:@@storage)
      .instance_variable_get(:@_id)).not_to eq(nil)
  end

  it "uses the defaults when 'true' is passed" do
    AppConfig.reset!
    AppConfig.setup!(mongo: true)

    expect(AppConfig.class_variable_get(:@@storage)
      .instance_variable_get(:@options)).to eq(AppConfig::Storage::Mongo::DEFAULTS)
  end

  it 'should reload the data' do
    AppConfig.reset!
    config_for_mongo(true, false)

    # Set a variable, but do not call AppConfig.save!
    AppConfig.true_option = false

    AppConfig.reload!

    expect(AppConfig.true_option).to eq(true)
  end

end
