
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'blertr/options'

describe Blertr::Options do
  before(:each) do
    @mail_options = Blertr::Options::options_for("mail")
  end

  it "should get options given name" do
    @mail_options.class.should == Hash
    @mail_options.empty?.should_not == true
    @mail_options[:username].should_not == nil
  end

  it "should have a valid config path and files" do
    config_file = Blertr::Options::config_file_for("mail")
    config_path = Blertr::Options::config_path
    File.exists?(config_file).should == true
    File.directory?(config_path).should == true
    config_files = Dir.glob(File.join(config_path, "*_config.yaml"))
    config_files.empty?.should == false
  end

  it "should be blank for missing notifiers" do
    Blertr::Options::remove_optons_for "missing"
    missing_options = Blertr::Options::options_for("missing")
    missing_options.empty?.should == true
  end

  it "should create for new notifiers" do
    missing_options = Blertr::Options::options_for("missing")
    missing_options.empty?.should == true

    missing_options[:time] = 123
    missing_options[:status] = "help"
    Blertr::Options::save_options_for "missing", missing_options

    not_missing_options = Blertr::Options::options_for("missing")
    not_missing_options.empty?.should == false

    Blertr::Options::remove_optons_for "missing"
  end
end
