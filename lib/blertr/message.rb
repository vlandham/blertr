module Blertr
  class Message
    SECS_IN_MIN = 60
    MIN_IN_HOUR = 60
    SEC_RANGE = (2..59)
    ONE_MIN_RANGE = (60..119)
    MINS_RANGE = (120..(SECS_IN_MIN * MIN_IN_HOUR - 1))
    attr_accessor :command, :seconds

    def initialize command, time
      self.command = command.strip
      self.seconds = time.to_i
    end

    def command_short_name
      self.command.split(/ /)[0]
    end

    def time_string
      case seconds
      when 1
        "1 second"
      when 0, SEC_RANGE
        "#{seconds} seconds"
      when ONE_MIN_RANGE
        "1 minute"
      when MINS_RANGE
        mins = seconds / SECS_IN_MIN
        "#{mins} minutes"
      else
        hours = (seconds.to_f / SECS_IN_MIN.to_f / MIN_IN_HOUR.to_f).round(2)
        if hours == 1.0
          "1 hour"
        else
          "#{hours} hours"
        end
      end
    end
  end
end
