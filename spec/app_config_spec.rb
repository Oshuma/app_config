require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ApiStore do
  it 'should have a version' do
    ApiStore.to_version.should_not be_nil
  end
end
