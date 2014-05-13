require 'spec_helper'

describe AppConfig::Storage::SQLite do

  before(:all) do
    config_for_sqlite
  end

  it 'should have some values' do
    AppConfig.api_key.should_not be_nil
  end

  it 'should reload the data' do
    # Save the old value, so we can make sure it hasn't changed.
    admin_email = AppConfig.admin_email

    # Set a value, but don't call AppConfig.save!
    AppConfig.admin_email = 'CHANGED'

    AppConfig.reload!

    AppConfig.admin_email.should == admin_email
  end

  it 'should update the values' do
    new_api_key = 'NEW_API_KEY'
    new_admin_email = 'new_admin@example.com'

    AppConfig.api_key = new_api_key
    AppConfig.admin_email = new_admin_email

    AppConfig.save!.should be_true

    # Reload AppConfig (passing `false` to avoid wiping test db).
    config_for_sqlite(false)

    AppConfig.api_key.should == new_api_key
    AppConfig.admin_email.should == new_admin_email
  end

  it 'should create a new row if @id is not set' do
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

end
