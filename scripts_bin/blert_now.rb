
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'blertr'

# interface between shell and ruby code
# not meant to be called directly by user
#
# input from shell is the command name that ran
# and how many seconds it ran for

command_name = ARGV[0]
command_seconds = ARGV[1].to_i
if command_name and command_seconds
  if RUBY_PLATFORM == 'java'
    puts "Blertr does not support jruby"
  else
    Blertr::Control::alert command_name, command_seconds
  end
else
  puts "usage: blertr_now command time_taken"
end

