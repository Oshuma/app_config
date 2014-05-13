require 'spec_helper'

describe AppConfig::Storage::MySQL do

  before(:all) do
    config_for_mysql(true)
  end

  it 'should have some values' do
    AppConfig.api_key.should_not be_nil
  end

  it 'should reload the data' do
    # Set a value, but don't call AppConfig.save!
    AppConfig.true_option = false

    AppConfig.reload!

    AppConfig.true_option.should == true
  end

  it 'should update the values' do
    new_api_key = 'NEW_API_KEY'
    new_admin_email = 'new_admin@example.com'

    AppConfig.api_key = new_api_key
    AppConfig.admin_email = new_admin_email

    AppConfig.save!.should be_true

    # Reload AppConfig
    config_for_mysql

    AppConfig.api_key.should == new_api_key
    AppConfig.admin_email.should == new_admin_email
  end

end
