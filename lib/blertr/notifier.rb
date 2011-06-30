require 'yaml'

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
      if name
        File.join(config_path, "#{name}_config.yaml")
      else
        ""
      end
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

    def set_time new_time
      opts = options
      opts[:time] = new_time
      save_options(opts)
    end

    def save_options new_options
      if File.exists? config_file
        File.open(config_file, 'w') do |file|
          file.puts(YAML::dump(new_options))
        end
      end
    end

    def will_alert? name, time
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

    def can_alert?
      false
    end
  end
end
