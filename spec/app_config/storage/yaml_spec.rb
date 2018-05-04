require 'spec_helper'

describe AppConfig::Storage::YAML do

  it 'should have some values' do
    config_for_yaml
    expect(AppConfig.api_key).not_to eq(nil)
  end

  it 'should raise file not found' do
    expect { config_for_yaml(yaml: 'not/a/real/file.yml') }.to raise_error(Errno::ENOENT)
  end

  it 'saves the new value in memory' do
    config_for_yaml
    AppConfig.new_key = 'new value'
    expect(AppConfig.new_key).to eq('new value')
  end

  it "requires the use of 'Dir.home'" do
    unless Dir.respond_to?(:home)
      fail "Requires 'Dir.home' which is available in Ruby 1.9"
    end
  end

  it "uses the defaults when 'true' is passed" do
    AppConfig.reset!

    # Hack to use spec config as the 'default'
    AppConfig::Storage::YAML::DEFAULT_PATH = fixture('app_config.yml')

    AppConfig.setup!(yaml: true)
    expect(AppConfig.api_key).not_to eq(nil)
  end

  it 'accepts an :env option' do
    AppConfig.setup!(yaml: fixture('app_config_env.yml'), env: :production)
    expect(AppConfig.production).to eq(true)
  end

  it 'accepts a String as :env option' do
    AppConfig.setup!(yaml: fixture('app_config_env.yml'), env: 'production')
    expect(AppConfig.production).to eq(true)
  end

  it 'should reload the data' do
    config_for_yaml
    original_api_key = AppConfig.api_key

    # Set to some random value:
    AppConfig.api_key = "foobar-#{rand(100)}"

    AppConfig.reload!
    expect(AppConfig.api_key).to eq(original_api_key)
  end

end
