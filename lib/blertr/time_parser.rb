module Blertr
  class TimeParser
    SECONDS_IN_MIN = 60
    SECONDS_IN_HOUR = 3600
    SECONDS_IN_DAY = 86400

    def self.to_seconds time_string
      time_seconds = 0
      if time_string =~ /^(\d+)$/
        # only digits. assume seconds
        time_seconds = $1.to_i
      elsif time_string =~ /^(\d+)\s+(\w+)$/
        # digits and words
        digits = $1.to_i
        mult = convert_word $2
        time_seconds = digits * mult
      end
      time_seconds = time_seconds > 0 ? time_seconds : nil

      time_seconds
    end

    def self.convert_word input_word
      multiplier = 1
      if input_word =~ /^s/
        multiplier = 1
      elsif input_word =~ /^m/
        multiplier = SECONDS_IN_MIN
      elsif input_word =~ /^(h|hour|hr)/
        multiplier = SECONDS_IN_HOUR
      elsif input_word =~ /^d/
        multiplier = SECONDS_IN_DAY
      end
      multiplier
    end
  end
end
