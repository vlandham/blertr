require 'fileutils'

module Blertr
  class Blacklist
    attr_accessor :path, :list

    def self.path
      File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "config", "blacklist.yaml"))
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
      @list.each do |name|
        if command =~ /^#{name}/
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
