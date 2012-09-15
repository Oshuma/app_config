require 'spec_helper'

describe AppConfig::Storage::Base do
  subject { AppConfig::Storage::Base.new({}) }

  it 'should set new pairs by store()' do
    subject.store(:key, 'value')
    subject[:key].should == 'value'
  end

  it 'should set new pairs by []=' do
    subject[:key] = 'value'
    subject[:key].should == 'value'
  end

  it 'should set new pairs by dynamic method' do
    subject.key = 'value'
    subject[:key].should == 'value'
  end
end
