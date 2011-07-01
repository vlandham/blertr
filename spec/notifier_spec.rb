require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'blertr/notifier'

describe Blertr::Notifier do
  before(:each) do
    @notifier = Blertr::Notifier.new
  end

  it "should have no default name" do
    @notifier.name.should == nil
  end


  it "should not have any options" do
    @notifier.options.empty?.should == true
  end

  it "should not be able to alert" do
    @notifier.can_alert?.should == false
  end

  it "should not alert by default" do
    @notifier.will_alert?("name", 233).should == false
  end

end
