require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Base do

  it 'should raise UnknownStorageMethod' do
    lambda do
      Base.new(:storage_method => 'not_a_real_storage_method')
    end.should raise_error(UnknownStorageMethod)
  end

  it 'should have default options' do
    default_path = File.expand_path(File.join(ENV['HOME'], '.app_config.yml'))
    # mock up the YAML stuff, so it won't puke
    YAML.should_receive(:load_file).with(default_path).and_return({:api => 'key'})
    base = Base.new
    base.instance_variable_get(:@options)[:storage_method].should == :yaml
  end

end
