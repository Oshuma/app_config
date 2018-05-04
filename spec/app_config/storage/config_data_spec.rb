require 'spec_helper'

describe AppConfig::Storage::ConfigData do

  it 'has a #to_hash method' do
    @data = Storage::ConfigData.new({foo: 'bar'})
    expect(@data.to_hash).to eq({foo: 'bar'})
  end

end
