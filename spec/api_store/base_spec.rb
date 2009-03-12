require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Base do

  it 'should raise error on unknown option' do
    lambda do
      Base.new(:unknown => 'option')
    end.should raise_error(NoMethodError)
  end

  it 'should have default options' do
    default_path = File.expand_path(File.join(ENV['HOME'], '.api_store.yml'))
    # mock up the YAML stuff, so it won't puke
    YAML.should_receive(:load_file).with(default_path).and_return({:api => 'key'})
    base = Base.new
    base.storage_method.should == :yaml
    base.path.should == default_path
  end

end
