require 'spec_helper'

describe AppConfig::Storage::Base do

  it 'accepts hash as default data' do
    config_for(default: 'data')
    AppConfig.default.should == 'data'
  end

end
