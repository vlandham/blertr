require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Blertr::TimeParser do
  before(:each) do
  end

  it "should convert time words" do
    ["seconds", "second", "sec", "secs", "s"].each do |sec_word|
      Blertr::TimeParser.convert_word(sec_word).should == 1
    end

    ["min", "mins", "minutes", "minute", "m"].each do |min_word|
      Blertr::TimeParser.convert_word(min_word).should == 60
    end

    ["h", "hrs", "hours", "hour"].each do |hr_word|
      Blertr::TimeParser.convert_word(hr_word).should == (60 * 60)
    end

    ["d", "days", "day"].each do |day_word|
      Blertr::TimeParser.convert_word(day_word).should == (60 * 60 * 24)
    end
  end

  it "should convert to seconds" do
    conversions = [["1 day", (60*60*24)], ["123", 123], ["2 mins", 120],
                   ["36 hours", (60*60*36)], ["1 second", 1], ["5 minutes", (60*5)]]
    conversions.each do |string, seconds|
      Blertr::TimeParser.to_seconds(string).should == seconds
    end
  end
end
