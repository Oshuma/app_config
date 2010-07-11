require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe 'MongoDB' do
  it 'connects to the MongoDB host' do
    pending "TODO: Spec this out"
  end

  it 'authenticates with MongoDB' do
    pending "TODO: Spec this out"
  end

  it 'should have some values' do
    config_for_mongo
    AppConfig[:api_key] = 'SOMESECRETKEY'
    AppConfig[:api_key].should_not be_nil
  end
end
