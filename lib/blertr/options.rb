require 'fileutils'
require 'blertr/constants'

module Blertr
  class Options
    def self.options_for name
      rtn = {}
      if File.exists? config_file_for(name)
        file = File.open(config_file_for(name),'r')
        yaml_data = YAML::load(file)
        file.close
        if yaml_data
          rtn = Hash[yaml_data.map {|k,v| [k.to_sym, v]}]
        end
      end
      rtn
    end

    def self.save_options_for name, new_options
      begin
      file = config_file_for name
      File.open(file, 'w') do |file|
        file.puts(YAML::dump(new_options))
      end
      rescue
        puts "problem saving options"
      end
    end

    def self.remove_optons_for name
      file = config_file_for name
      if File.exists? file
        FileUtils.rm(file)
      end
    end

    def self.config_path
      # first try local config
      path = File.expand_path(CONFIG_DIR_PATH)
      if !File.exists?(path)
        path = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config"))
      end
      path
    end

    def self.config_file_for name
      if name
        File.join(config_path, "#{name}_config.yaml")
      else
        ""
      end
    end
  end
end
