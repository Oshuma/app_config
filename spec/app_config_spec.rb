require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe AppConfig do
  it 'should have a version' do
    AppConfig.to_version.should_not be_nil
  end
end
