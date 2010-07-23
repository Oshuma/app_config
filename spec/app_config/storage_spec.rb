require 'spec_helper'

describe AppConfig::Storage do

  it 'responds to .setup()' do
    AppConfig.should respond_to(:setup)
  end

end
