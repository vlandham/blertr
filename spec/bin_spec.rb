BIN = File.expand_path(File.join(File.dirname(__FILE__), "..", "bin", "blertr"))

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'blertr/bin'

describe Blertr::Bin do
  describe "blertr" do
    before(:each) do
      @bin = BIN
    end

    it "should exist" do
      File.exists?(@bin).should == true
    end

    it "should be executable" do
      File.executable?(@bin).should == true
    end
  end

  describe "bin" do
    before(:each) do
      @bin = Blertr::Bin
      @invalid_notifiers = ["", "maill", "mad", nil, "gr0wl", "ddd", "      dd     "]
    end

    it "should print help with no action or help action" do
      actions = [nil, "help"]
      actions.each do |action|
        output = capture(:stdout) {@bin.take_action action, nil}
        output.should match(/Welcome to Blertr/)
      end
    end

    it "should print time for all notifiers with no time parameters" do
      output = capture(:stdout) {@bin.take_action "time", nil}
      output.should match(/All Notifier Times/)
    end

    it "should indicate notifier is invalid for invalid notifiers" do
      output = capture(:stdout) {@bin.take_action "time", "not_notifier"}
      output.should match(/isn't a notifier/)
    end

    it "should error if no time is given to set for notifier" do
      output = capture(:stdout) {@bin.take_action "time", "mail"}
      output.should match(/Error/)
      output.should match(/requires a new time/)
    end

    it "should not set configs for invalid notifier" do
      @invalid_notifiers.each do |notifier|
        output = capture(:stdout) {@bin.take_action "set", notifier }
        output.should match(/Error/)
        output.should match(/isn't a notifier/)
      end
    end

    it "should not exclude empty commands" do
      invalid_exclusions = [nil, "", "          "]
      invalid_exclusions.each do |ex|
        output = capture(:stdout) {@bin.take_action "exclude", ex }
        output.should match(/Error/)
        output.should match(/requires .* command .* exclude/)
      end
    end

    it "should show info of all notifiers if no notifier name given" do
        output = capture(:stdout) {@bin.take_action "info", nil }
        output.should match(/Configuration for: mail/)
        output.should match(/Configuration for: twitter/)
        output = capture(:stdout) {@bin.take_action "info", "     " }
        output.should match(/Configuration for: mail/)
        output.should match(/Configuration for: twitter/)
    end
  end
end
