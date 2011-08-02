require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Blertr::Message do

  describe "advanced short names" do
    before(:each) do
      @seconds = 240
    end
    it "should figure out base paths to commands" do
      path_commands = {"../start.sh 123 -h -o" => "start.sh",
                       "/usr/bin/ruby -v ./runner.rb" => "ruby",
                       "../../../commands/bin -kill destroy" => "bin"}
      path_commands.each do |command, short_name|
        message = Blertr::Message.new(command, @seconds)
        message.command_short_name.should == short_name
      end
    end
  end
  describe "basic functionality" do
    before(:each) do
      @command = "cp -r ./ddd/aaa /aaa/ddd"
      @short_name = "cp"
      @seconds = 240
      @message = Blertr::Message.new(@command, @seconds)
    end

    it "should output command name" do
      @message.command.should == @command
    end

    it "should output time in seconds" do
      @message.seconds.should == @seconds
    end

    it "should output command short name" do
      @message.command_short_name.should == @short_name
    end
  end
  describe "time string" do
    before(:each) do
      @command = "cp -r ./ddd/aaa /aaa/ddd"
      @short_name = "cp"
      @message = Blertr::Message.new(@command, 0)
      @one_min = 60
      @min_per_hour = 60
    end

    it "should describe time in seconds" do
      [0, 10, 20, 35, 45, 55, 59].each do |seconds|
        @message.seconds = seconds
        @message.time_string.should == "#{seconds} seconds"
      end
      @message.seconds = 1
      @message.time_string.should == "1 second"
    end

    it "should describe time in minutes" do
      @message.seconds = 60
      @message.time_string.should == "1 minute"
      (2..59).each do |min|
        seconds = min * @one_min
        @message.seconds = seconds
        @message.time_string.should == "#{min} minutes"
      end
    end

    it "should describe time in hours" do
      hour = 60 * 60
      @message.seconds = hour
      @message.time_string.should == "1 hour"
      (2..59).each do |hour|
        seconds = hour * @one_min * @min_per_hour
        @message.seconds = seconds
        @message.time_string.should == "#{hour.to_f} hours"
      end
    end
  end
end
