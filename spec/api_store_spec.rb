require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ApiStore do
  before(:each) do
    @valid_options = {
      :storage_method => :yaml,
    }
  end

  it 'should have a version' do
    ApiStore.to_version.should_not be_nil
  end

  it 'should raise error on unknown option' do
    lambda do
      ApiStore.configure(@valid_options.merge(:unknown => 'option'))
    end.should raise_error(NoMethodError)
  end

  it 'should accept a config block' do
    ApiStore.configure {|c| c}.should_not be_nil
  end
end
