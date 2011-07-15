require 'blertr/message'
require 'blertr/mail_notifier'
require 'blertr/growl_notifier'
require 'blertr/twitter_notifier'
require 'blertr/notify_send_notifier'
require 'blertr/time_parser'
require 'blertr/blacklist.rb'

module Blertr
  class Control
    # Sends out alert from each notifier if
    # time passed is long enough
    def self.alert command_name, command_time
      blacklist = Blacklist.new
      if !blacklist.blacklisted?(command_name)
        message = Message.new(command_name, command_time)
        notifiers.each do |notifier|
          if notifier.will_alert?(message.command, message.seconds)
            fork do
              begin
                notifier.alert message
              rescue
                puts "problem with #{notifier.name} alert"
              end
              exit
            end
          end
        end
      end
    end

    def self.notifiers
      noters = []
      noters << MailNotifier.new
      noters << GrowlNotifier.new
      noters << TwitterNotifier.new
      noters << NotifySendNotifier.new
      noters
    end

    def self.notifier_with_name name
      notifiers.each do |notifier|
        if name == notifier.name
          return notifier
        end
        if notifier.names.include? name
          return notifier
        end
      end
      nil
    end

    def self.is_notifier? name
      notifier_with_name(name) != nil
    end

    def self.change_time name, time_string
      time_seconds = TimeParser::to_seconds time_string
      if time_seconds.nil?
        puts "ERROR: not valid time: #{time_string}"
      else
        notifier = notifier_with_name name
        if notifier
          puts "setting #{name} to alert after #{time_seconds} seconds"
          notifier.set_time time_seconds
        end
      end
    end
  end
end
