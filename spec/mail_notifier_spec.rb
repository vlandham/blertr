
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'blertr/mail_notifier'


describe Blertr::MailNotifier do
  before(:each) do
    @notifier = Blertr::MailNotifier.new
  end

  it "should have a name" do
    @notifier.name.should == "mail"
  end

  it "should have a valid config file" do
    File.exists?(@notifier.config_file).should == true
  end

  it "should have options from the config file" do
    @notifier.options.empty?.should == false
    @notifier.options[:username].class.should == String
    @notifier.options[:time].class.should == Fixnum
  end

  it "should be capable of alerting" do
    @notifier.can_alert?.should == true
  end

  it "should alert if time is in range" do
    @notifier.options[:time] = 20
    @notifier.will_alert?("name", 21).should == true
    @notifier.will_alert?("name", 19).should == false
    @notifier.options[:time] = 19
    @notifier.will_alert?("name", 19).should == true
    @notifier.will_alert?("name", 20000).should == true
    @notifier.options[:time] = 20001
    @notifier.will_alert?("name", 20000).should == false
  end
end
