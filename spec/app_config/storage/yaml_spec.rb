require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include AppConfig::Storage
describe Yaml do

  it 'should have some values' do
    config_for_yaml
    AppConfig[:api_key].should_not be_nil
  end

  it 'should raise file not found' do
    lambda do
      config_for_yaml(:path => 'not/a/real/file.yml')
    end.should raise_error(Errno::ENOENT)
  end

end
