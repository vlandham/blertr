require 'blertr/notifier'

module Blertr
  class NotifySendNotifier < Notifier
    def initialize
      super
      @names = ["notify_send"]
    end

    def alert message
      #TODO: look to supporting other growl frameworks on other OSs
      system("notify-send \"#{message.command}\" \"took #{message.time_string}\"")
    end

    def can_alert?
      system("which notify-send > /dev/null 2>&1")
    end
  end
end
