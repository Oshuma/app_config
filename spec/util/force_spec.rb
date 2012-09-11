require 'spec_helper'
require './lib/util/force'

describe Force do
  it "should be_true" do
    options_hash = {:force => true}
    subject = Force.new(options_hash)
    subject.should be_set
    subject.true?.should be_true
  end

  it "should be_false" do
    options_hash = {:force => false}
    subject = Force.new(options_hash)
    subject.should be_set
    subject.should_not be_nil
    subject.true?.should be_false
    subject.false?.should be_true
  end

  it "should be_nil?" do
    options_hash = {:key => :value}
    subject = Force.new(options_hash)
    subject.should_not be_set
    subject.should be_nil
  end
end
