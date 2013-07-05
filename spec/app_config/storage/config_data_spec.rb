require 'spec_helper'

describe AppConfig::Storage::ConfigData do

  it 'has a #to_hash method' do
    @data = Storage::ConfigData.new({foo: 'bar'})
    @data.to_hash.should == {foo: 'bar' }
  end

end
