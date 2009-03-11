require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include ApiStore
describe Base do

  it 'should raise error on unknown option' do
    lambda do
      Base.new(:unknown => 'option')
    end.should raise_error(NoMethodError)
  end

end
