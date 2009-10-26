require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include AppConfig::Storage
describe Sqlite do
  it 'should not find the database' do
    lambda do
      config_for_sqlite(:database => 'not/a/real/database.sqlite3')
    end.should raise_error(SQLite3::CantOpenException)
  end

  it 'should have some values' do
    config_for_sqlite
    AppConfig[:api_key].should_not be_nil
  end

  it 'should honor the :env option' do
    pending "TODO: Still haven't made up my mind on how I want to do this"
  end
end
