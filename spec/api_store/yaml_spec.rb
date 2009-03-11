require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

FIXTURE = File.expand_path(File.dirname(__FILE__) + '/../fixtures/api_store.yml')

include ApiStore
describe Yaml do

  before(:each) do
    @yaml = {
      :storage_method => :yaml,
      :path => FIXTURE,
    }
  end

  it 'should have a test_api_key' do
    ApiStore.configure(@yaml)
    ApiStore['test_api_key'].should_not be_nil
  end

  it 'should raise file not found' do
    lambda do
      ApiStore.configure(@yaml.merge(:path => 'not/a/real/file.yml'))
    end.should raise_error(Errno::ENOENT)
  end

end
