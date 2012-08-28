require 'spec_helper'

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

  it 'should be convertable to YAML with strings' do
    hashish = Hashish.new(@strings)
    hashish.to_yaml.should eq "---\nkey: value\nfour: 20\n"
  end

  it 'should be convertable to YAML with symbols' do
    hashish = Hashish.new(@symbols)
    hashish.to_yaml.should eq "---\nkey: value\nfour: 20\n"
  end

  it 'should be saveable' do
    config_file = temp_config_file

    hashish = Hashish.new(@symbols)
    hashish.save!(config_file, :format => :yaml)
    hashish.to_yaml.should eq File.read(config_file)
  end
end
