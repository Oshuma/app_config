require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

FIXTURE = File.expand_path(File.dirname(__FILE__) + '/../fixtures/api_store.yml')

include ApiStore
describe Yaml do

  before(:each) do
    @yaml = {
      :storage_method => :yaml,
      :path => FIXTURE,
    }
    ApiStore.configure(@yaml)
  end

  it 'should have a test_api_key' do
    ApiStore['test_api_key'].should_not be_nil
  end

end
