require 'spec_helper'

describe AppConfig::Storage::Postgres do

  before(:all) do
    config_for_postgres(true)
  end

  it 'should have some values' do
    AppConfig.api_key.should_not be_nil
  end

  it 'should update the values' do
    new_api_key = 'SOME_NEW_API_KEY'
    AppConfig.api_key = new_api_key

    AppConfig.save!.should be_true

    # Reload AppConfig
    config_for_postgres

    AppConfig.api_key.should == new_api_key
  end

  it "uses the defaults when 'true' is passed" do
    AppConfig.reset!

    # Hack to use a test database as the 'default'.
    AppConfig::Storage::Postgres::DEFAULTS[:dbname] = 'app_config_test'

    begin
      AppConfig.setup!(postgres: true)
    rescue PG::Error => e
      config_for_postgres
    end

    AppConfig.class_variable_get(:@@storage)
      .instance_variable_get(:@options)
      .should == AppConfig::Storage::Postgres::DEFAULTS
  end

end
