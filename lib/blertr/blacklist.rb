require 'fileutils'
require 'blertr/constants'

module Blertr
  class Blacklist
    attr_accessor :path, :list

    def self.path
      base_path = File.expand_path(CONFIG_DIR_PATH)
      if File.exists?(base_path)
        File.join(base_path, "blacklist.yaml")
      else
        File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config", "blacklist.yaml"))
      end
    end

    def initialize path = Blacklist::path
      @path = path
      @list = []
      if !File.exists?(@path)
        create
      end
      file = File.open(@path, 'r')
      yaml_data = YAML::load(file)
      file.close
      @list = yaml_data.to_a if yaml_data
    end

    def add name
      @list << conform(name)
      save @list
    end

    def conform name
      name.downcase.strip
    end

    def blacklisted? command
      rtn = false
      command_fields = command.split(/ /)
      list_matches = @list.collect {|name| name.split(/ /).zip(command_fields)}

      list_matches.each do |match_set|
        match = true
        match_set.each do |excluded_section, command_section|
          if (excluded_section and command_section) and
            (excluded_section != command_section) and
            (File.basename(excluded_section) != File.basename(command_section))
            match = false
          end
        end

        if match
          rtn = true
          return rtn
        end
      end
      rtn
    end

    def clear
      if File.exists? @path
        FileUtils.rm(@path)
      end
    end

    def save new_list
      File.open(@path, 'w') do |file|
        file.puts(YAML::dump(new_list))
      end
    end

    def create
      system("touch #{@path}")
    end
  end

end
