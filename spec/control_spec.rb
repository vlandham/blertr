
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Blertr::Control do
  before(:each) do
  end

  it "should load notifiers" do
    Blertr::Control::notifiers.empty?.should_not == true
    notifier_names = Blertr::Control::notifiers.collect {|n| n.name}
    notifier_names.include?('mail').should == true
    notifier_names.include?(nil).should == false
  end

  it "should distinguish notifier names" do
    notifier_names = Blertr::Control::notifiers.collect {|n| n.name}
    notifier_names.each {|name| Blertr::Control::is_notifier?(name).should == true}
  end

  it "should distinguish bad notifier names" do
    bad_names = ["asdf", 123, nil, "DdDdDd"]
    bad_names.each {|name| Blertr::Control::is_notifier?(name).should == false}
  end

  it "should distinguish alias names" do
    alias_names = ["mail", "tweet"]
    alias_names.each {|name| Blertr::Control::is_notifier?(name).should == true}
  end

  it "should get notifier with name" do
    notifier = Blertr::Control::notifier_with_name 'mail'
    notifier.name.should == 'mail'
  end

  it "should return nil for invalid notifier" do
    notifier = Blertr::Control::notifier_with_name 'caterall'
    notifier.should == nil
  end
end
