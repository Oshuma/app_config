require 'spec_helper'

describe AppConfig::Storage::MySQL do

  before(:all) do
    config_for_mysql(true)
  end

  it 'should have some values' do
    AppConfig.api_key.should_not be_nil
  end

end
