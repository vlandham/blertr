module Blertr
  class Notifier
    def initialize
    end

    def should_alert? name, time
      rtn = self.can_alert?
      if rtn

      end
      rtn
    end

    def alert
    end

    def can_alert?
      false
    end
  end
end
