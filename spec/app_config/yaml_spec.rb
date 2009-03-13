require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Yaml do

  it 'should have a test_api_key' do
    config_for_yaml
    ApiStore['test_api_key'].should_not be_nil
  end

  it 'should raise file not found' do
    lambda do
      config_for_yaml(:path => 'not/a/real/file.yml')
    end.should raise_error(Errno::ENOENT)
  end

end
