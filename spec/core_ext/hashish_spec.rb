require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hashish do
  before(:each) do
    @strings = { 'key' => 'value', 'four' => 20 }
    @symbols = { :key  => 'value', :four  => 20 }
  end

  it 'should not give a fuck about symbols' do
    hashish = Hashish.new(@strings)
    hashish[:key].should == 'value'
  end

  it 'should not give a fuck about strings' do
    hashish = Hashish.new(@symbols)
    hashish['key'].should == 'value'
  end
end
