require 'spec_helper'

describe AppConfig::Storage::SQLite do

  before(:all) do
    config_for_sqlite
  end

  it 'should have some values' do
    AppConfig.api_key.should_not be_nil
  end

end
