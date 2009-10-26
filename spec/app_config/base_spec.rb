require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Base do

  it 'should raise UnknownStorageMethod' do
    lambda do
      Base.new(:storage_method => 'not_a_real_storage_method')
    end.should raise_error(Error::UnknownStorageMethod)
  end

  describe 'default options' do
    before(:all) do
      @base = Base.new
    end

    it 'storage_method should be :memory' do
      @base.instance_variable_get(:@options)[:storage_method].should == :memory
    end

    it 'uri should be nil' do
      @base.instance_variable_get(:@options)[:uri].should be_nil
    end
  end

  it 'should set the storage_method to :sqlite' do
    uri = "sqlite://#{fixture('app_config.sqlite3')}"
    base = Base.new(:uri => uri)
    base.instance_variable_get(:@options)[:storage_method].should == :sqlite
  end

  it 'should set the storage_method to :yaml' do
    uri = "yaml://#{fixture('app_config.yml')}"
    base = Base.new(:uri => uri)
    base.instance_variable_get(:@options)[:storage_method].should == :yaml
  end
end
