require 'spec_helper'
require './lib/util/force'

describe Force do
  context "when hash includes :force => true" do
    options_hash = {:force => true}
    subject { Force.new(options_hash) }

    it "should be set" do
      subject.should be_set
    end

    it "should not be nil" do
      subject.should_not be_nil
    end

    it "should be true" do
      subject.true?.should be_true
    end

    it "should not be false" do
      subject.false?.should be_false
    end

    it "#to_s" do
      subject.to_s.should eq "true"
    end
  end

  context "when hash includes :force => false" do
    options_hash = {:force => false}
    subject { Force.new(options_hash) }

    it "should be set" do
      subject.should be_set
    end

    it "should not be nil" do
      subject.should_not be_nil
    end

    it "should not be true" do
      subject.true?.should be_false
    end

    it "should be false" do
      subject.false?.should be_true
    end

    it "#to_s" do
      subject.to_s.should eq "false"
    end
  end

  context "when hash doesn't include :force" do
    options_hash = {:key => :value}
    subject { Force.new(options_hash) }

    it "should not be set" do
      subject.should_not be_set
    end

    it "should be nil" do
      subject.should be_nil
    end

    it "should not be true" do
      subject.true?.should be_false
    end

    it "should not be false" do
      subject.false?.should be_false
    end

    it "#to_s" do
      subject.to_s.should eq "unset"
    end
  end
end
