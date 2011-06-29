module Blertr
  class Notifier
    attr_reader :name
    def initialize
      @name = nil
    end

    def config_path
      File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config"))
    end

    def config_file
      File.join(config_path, "#{name}_config.yaml")
    end

    def options
      @options ||= get_options
      @options
    end

    def get_options
      rtn = {}
      if File.exists? config_file
        yaml_data = YAML::load(open(config_file))
        if yaml_data
          rtn = Hash[yaml_data.map {|k,v| [k.to_sym, v]}]
        end
      end
      rtn
    end

    def should_alert? name, time
      rtn = self.can_alert?
      if rtn
        rtn = in_time_window? time
      end
      rtn
    end

    def in_time_window? time
      rtn = false
      time_min = options[:time]
      if time_min and time >= time_min
        rtn = true
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
