require 'blertr/notifier'
require 'yaml'
require 'net/smtp'

module Blertr
  class MailNotifier < Notifier
    def initialize
      @name = "mail"
      @config_file = File.join(File.dirname(__FILE__), "..", "..", "config", "mail_config.yaml")
    end

    def alert name, time
      username = @options[:username]
      password = @options[:password]
      receiver = @options[:to]
      msg = message name, time
      smtp = Net::SMTP.new 'smtp.gmail.com', 587
      smtp.enable_starttls
      smtp.start('gmail.com', username, password, :login) do
        smtp.send_message(msg, "#{username}@gmail.com", receiver)
      end
    end

    def message name, time
      first_name = name.split(" ")[0]
      msg = "Subject: #{first_name} is done!\n"
      msg += "#{first_name} has completed.\nFull Command:#{name}\nTime Taken:#{time} seconds\n"
      msg
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
    end
  end
end
