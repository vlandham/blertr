require 'blertr/notifier'

module Blertr
  class NotifySendNotifier < Notifier
    def initialize
      super
      @names = ["notify_send"]
    end

    def alert message
      system("notify-send \"#{message.command}\" \"took #{message.time_string}\" 2> /dev/null")
    end

    def can_alert?
      rtn = system("which notify-send > /dev/null 2>&1")
      error_messages << "notify-send not availible from $PATH" unless rtn
      rtn
    end
  end
end
