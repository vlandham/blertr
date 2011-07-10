
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Blertr::Blacklist do
  before(:each) do
    @blacklist_path = File.expand_path(destination_root + "/blacklist.yaml")
    @blacklist = Blertr::Blacklist.new(@blacklist_path)
  end

  after(:each) do
    @blacklist.clear
  end

  it "should load blank blacklist" do
    blacklist_path = File.expand_path(destination_root + "/fakelist.yaml")
    blacklist = Blertr::Blacklist.new(blacklist_path)
    blacklist.list.should == []
  end

  it "should add name" do
    name = "git"
    @blacklist.add name
    @blacklist.list.should == [name]
    another_name = "ssh"
    @blacklist.add another_name
    @blacklist.list.should == [name,another_name]
  end

  it "should store names" do
    name = "git"
    @blacklist.add name
    another_name = "ssh"
    @blacklist.add another_name
    another_blacklist = Blertr::Blacklist.new(@blacklist_path)
    another_blacklist.list.should == [name, another_name]
  end

  it "should indicate blocked programs" do
    names = ["git", "ssh", "once_over" "dadada"]
    not_blocked = ["cp", "ssl", "screen", "mv"]
    blacklist_path = File.expand_path(destination_root + "/blacklist.yaml")
    blacklist = Blertr::Blacklist.new(blacklist_path)
    names.each do |name|
      blacklist.add name
      blacklist.blacklisted?(name).should == true
      not_blocked.each {|np| blacklist.blacklisted?(np).should == false}
    end
    blacklist.clear
  end

  it "should handle full commands" do
    commands = [["git diff","git diff"], ["ssh", "ssh 123@123.com"], ["cp", "cp /ma/da ./da/ma"]]

    commands.each do |name, command|
      @blacklist.add name
      @blacklist.blacklisted?(command).should == true
    end
  end

  it "should not exclude similar commands" do
    commands = [["git diff","git diff", "git log"], ["ssh", "ssh 123@123.com", "scp 123@123.com"], ["cp", "cp /ma/da ./da/ma"]]
    commands.each do |name, command, similar_command|
      @blacklist.add name
      @blacklist.blacklisted?(command).should == true
      @blacklist.blacklisted?(similar_command).should == false
    end
  end
end
