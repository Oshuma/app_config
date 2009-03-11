require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ApiStore
describe Yaml do

  before(:each) do
    @yaml = {
      :storage_method => :yaml,
      :path => 'test_storage.yaml',
    }
  end

  it 'should have a test_api key' do
    pending
    ApiStore.configure(@yaml)
    ApiStore[:test_api].should_not be_nil
  end

end