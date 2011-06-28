require 'blertr/notifier'
require 'yaml'
require 'gmail'

module Blertr
  class MailNotifier < Notifier
    def initialize
      @name = "mail"
      @config_file = File.join(File.dirname(__FILE__), "..", "..", "config", "mail_config.yaml")
    end

    def alert name, time
      gmail = Gmail.new(@options[:username], @options[:password])
      gmail.deliver do
        to "#{@options[:to]}"
        subject "#{name} is done"
        body "#{name} has finished running.\nTotal Running Time: #{time} seconds"
      end
      gmail.logout
    end

    def can_alert?
      rtn = File.exists? @config_file
      if rtn
        yaml_data = YAML::load(open(@config_file))
        @options = Hash[yaml_data.map {|k,v| [k.to_sym, v]}] if yaml_data
        rtn &= @options[:username]
        rtn &= @options[:password]
        rtn &= @options[:to]
      end
      rtn
      false
    end
  end
end
