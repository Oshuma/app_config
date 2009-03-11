require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ApiStore do
  before(:each) do
    @yaml = {
      :storage_method => :yaml,
      :path => 'test_storage.yaml',
    }
  end

  it 'should have a version' do
    ApiStore.to_version.should_not be_nil
  end

  it 'should raise error on unknown option' do
    lambda do
      ApiStore.configure(@yaml.merge(:unknown => 'option'))
    end.should raise_error(NoMethodError)
  end

  it 'should accept a config block' do
    ApiStore.configure {|c| c}.should_not be_nil
  end
end
