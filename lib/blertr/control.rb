
require 'blertr/mail_notifier'
require 'blertr/growl_notifier'
require 'blertr/time_parser'

module Blertr
  class Control
    def self.alert command_name, command_time
      notifiers.each do |notifier|
        if notifier.will_alert? command_name, command_time
          begin
            notifier.alert command_name, command_time
          rescue
            puts "problem with #{notifier.name} alert"
          end
        end
      end
    end

    def self.notifiers
      noters = []
      noters << MailNotifier.new
      noters << GrowlNotifier.new
      noters
    end

    def self.notifier_with_name name
      notifiers.each do |notifier|
        if name == notifier.name
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
