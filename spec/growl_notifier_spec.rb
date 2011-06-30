
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'blertr/growl_notifier'

describe Blertr::GrowlNotifier do
  before(:each) do
    @notifier = Blertr::GrowlNotifier.new
  end

  it "should have a name" do
    @notifier.name.should == "growl"
  end

  it "should be able to alert" do
    #TODO: fix to be only true if growl_notify is installed
    @notifier.can_alert?.should == true
  end
end
