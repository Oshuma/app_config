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
    new_admin_email = 'foo@example.com'

    AppConfig.api_key = new_api_key
    AppConfig.admin_email = new_admin_email

    AppConfig.save!.should be_true

    # Reload AppConfig
    config_for_postgres

    AppConfig.api_key.should == new_api_key
    AppConfig.admin_email.should == new_admin_email
  end

  it "uses the defaults when 'true' is passed" do
    AppConfig.reset!

    # HACK: Use test values as the 'defaults'.
    old_host = AppConfig::Storage::Postgres::DEFAULTS[:host]
    AppConfig::Storage::Postgres::DEFAULTS[:host] = 'postgres_db'
    old_user = AppConfig::Storage::Postgres::DEFAULTS[:user]
    AppConfig::Storage::Postgres::DEFAULTS[:user] = 'postgres'
    old_dbname = AppConfig::Storage::Postgres::DEFAULTS[:dbname]
    AppConfig::Storage::Postgres::DEFAULTS[:dbname] = 'app_config_test'

    begin
      AppConfig.setup!(postgres: true)
    rescue PG::Error => e
      config_for_postgres
    end

    AppConfig.class_variable_get(:@@storage)
      .instance_variable_get(:@options)
      .should == AppConfig::Storage::Postgres::DEFAULTS

    # HACK: Reset original default values.
    AppConfig::Storage::Postgres::DEFAULTS[:host] = old_host
    AppConfig::Storage::Postgres::DEFAULTS[:user] = old_user
    AppConfig::Storage::Postgres::DEFAULTS[:dbname] = old_dbname
  end

  it "should create a new row if @id is not set" do
    # HACK: Save the old id so we can reset it.
    original_id = AppConfig.class_variable_get(:@@storage)
      .instance_variable_get(:@id)

    AppConfig.class_variable_get(:@@storage)
      .instance_variable_set(:@id, nil)

    AppConfig.api_key = 'foobar'
    AppConfig.save!.should be_true

    # HACK: Reset the original id.
    AppConfig.class_variable_get(:@@storage)
      .instance_variable_set(:@id, original_id)
  end

  it "turns Postgres booleans into Ruby objects" do
    # set in spec/fixtures/app_config.yml
    AppConfig.true_option.class.should  == TrueClass
    AppConfig.false_option.class.should == FalseClass
  end

  it 'should reload the data' do
    # Set a variable, but do not call AppConfig.save!
    AppConfig.true_option = false

    AppConfig.reload!

    AppConfig.true_option.should == true
  end

end
