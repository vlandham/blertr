require 'blertr/notifier'

module Blertr
  class GrowlNotifier < Notifier
    def initialize
      super
      @names = ["growl"]
    end

    def alert message
      system("growlnotify -n \"Terminal\" -m \"took #{message.time_string}\" \"#{message.command}\"")
    end

    def can_alert?
      rtn = system("which growlnotify > /dev/null 2>&1")
      error_messages << "growlnotify not availible from $PATH" unless rtn
      rtn
    end
  end
end
