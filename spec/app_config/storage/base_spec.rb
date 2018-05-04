require 'spec_helper'

describe AppConfig::Storage::Base do

  it 'accepts hash as default data' do
    config_for(default: 'data')
    expect(AppConfig.default).to eq('data')
  end

end
