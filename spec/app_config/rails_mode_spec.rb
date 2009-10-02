require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require File.expand_path(File.dirname(__FILE__) + '/../mock_rails')
Rails = MockRails.new

describe 'Rails Mode' do
  it 'should load the environment section of the YAML' do
    AppConfig.setup do |config|
      config[:uri] = "yaml://#{fixture('rails_app_config.yml')}"
      config[:rails] = true
    end
    AppConfig[:api_key].should_not be_nil
  end
end
