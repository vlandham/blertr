require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'blertr/notifier'

describe Blertr::Notifier do
  before(:each) do
    @notifier = Blertr::Notifier.new
  end

  it "should have no default name" do
    @notifier.name.should == nil
  end

  it "should have a valid config path" do
    File.exists?(@notifier.config_path).should == true
    File.directory?(@notifier.config_path).should == true
    config_files = Dir.glob(File.join(@notifier.config_path, "*_config.yaml"))
    config_files.empty?.should == false
  end

  it "should not have any options" do
    @notifier.options.empty?.should == true
  end

  it "should not have a config file" do
    @notifier.config_file.should == ""
  end

  it "should not be able to alert" do
    @notifier.can_alert?.should == false
  end

  it "should not alert by default" do 
    @notifier.will_alert?("name", 233).should == false
  end

end
