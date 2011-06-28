
require 'blertr/mail_notifier'
require 'blertr/growl_notifier'

module Blertr
  class Control
    def self.alert command_name, command_time
      notifiers.each do |notifier|
        if notifier.should_alert? command_name, command_time
          notifier.alert command_name, command_time
        end
      end
    end

    def self.notifiers
      noters = []
      noters << MailNotifier.new
      noters << GrowlNotifier.new
      noters
    end
  end
end
