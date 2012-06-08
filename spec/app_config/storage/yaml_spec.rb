require 'spec_helper'

describe AppConfig::Storage::YAML do

  it 'should have some values' do
    config_for_yaml
    AppConfig[:api_key].should_not be_nil
  end

  it 'should raise file not found' do
    lambda do
      config_for_yaml(:yaml => 'not/a/real/file.yml')
    end.should raise_error(Errno::ENOENT)
  end

  it 'saves the new value in memory' do
    config_for_yaml
    AppConfig[:new_key] = 'new value'
    AppConfig[:new_key].should == 'new value'
  end

end
