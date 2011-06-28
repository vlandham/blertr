require 'blertr/notifier'

module Blertr
  class GrowlNotifier < Notifier
    def alert name, time
      system("growlnotify -n \"Terminal\" -m \"took #{time} secs\" #{name}")
    end

    def can_alert?
      results = %x[which growlnotify]
      !results.nil? and !results.empty?
    end
  end
end
