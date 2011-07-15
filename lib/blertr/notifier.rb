require 'yaml'
require 'blertr/options'

module Blertr
  class Notifier
    attr_reader :names
    def initialize
      @names = []
    end

    def name
      (!@names or @names.empty?) ? nil : @names[0]
    end

    def options
      @options ||= Options::options_for name
      @options
    end

    def set_time new_time
      opts = options
      opts[:time] = new_time
      Options::save_options_for name, opts
    end

    def will_alert? name, time
      rtn = self.can_alert?
      if rtn
        rtn = in_time_window? time
      end
      rtn
    end

    def alert message
    end

    def in_time_window? time
      rtn = false
      time_min = options[:time]
      if time_min and time >= time_min
        rtn = true
      end
      rtn
    end

    def can_alert?
      false
    end
  end
end
