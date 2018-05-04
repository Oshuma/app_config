require 'spec_helper'

describe AppConfig do

  it 'has a version' do
    expect(AppConfig::VERSION).not_to eq(nil)
  end

  it 'responds to .setup!()' do
    expect(AppConfig).to respond_to(:setup!)
  end

  it 'responds to .setup?()' do
    expect(AppConfig).to respond_to(:setup?)
  end

  it 'responds to .reset!()' do
    expect(AppConfig).to respond_to(:reset!)
  end

  it 'should have to_hash' do
    config_for_yaml
    expect(AppConfig.to_hash.class).to eq(Hash)
  end

  it 'should reset @@storage' do
    # configure first
    config_for_yaml
    # then reset
    AppConfig.reset!
    expect(AppConfig.send(:storage)).to eq(nil)
  end

  it 'to_hash() returns an empty hash if storage not set' do
    AppConfig.reset!
    expect(AppConfig.to_hash).to eq({})
  end

  it 'should not be setup' do
    AppConfig.reset!
    expect(AppConfig).not_to be_setup
  end

  it 'should be setup' do
    config_for_yaml
    expect(AppConfig).to be_setup
  end

  it 'returns a Hash on setup' do
    AppConfig.reset!
    config = AppConfig.setup! do |c|
      c.name = 'Dale'
      c.nick = 'Oshuma'
    end
    expect(config).to be_instance_of(Hash)
  end

  it 'raises NotSetup if .storage is accessed and .setup! has not been called' do
    AppConfig.remove_class_variable(:@@storage)
    expect { AppConfig.save! }.to raise_error(AppConfig::Error::NotSetup)
  end

end
