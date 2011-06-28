require 'blertr/notifier'

module Blertr
  class MailNotifier < Notifier
    def alert name, time
    end
    def can_alert?
      false
    end
  end
end
