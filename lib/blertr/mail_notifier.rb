require 'blertr/notifier'
require 'net/smtp'

module Blertr
  class MailNotifier < Notifier
    def initialize
      super
      @names = ["mail", "email"]
    end

    def alert message
      username = options[:username]
      password = options[:password]
      receiver = options[:to]
      msg = create_message(message)
      smtp = Net::SMTP.new 'smtp.gmail.com', 587
      smtp.enable_starttls
      smtp.start('gmail.com', username, password, :login) do
        smtp.send_message(msg, "#{username}@gmail.com", receiver)
      end
    end

    def create_message message
      msg = "Subject: #{message.command_short_name} is done!\n"
      msg += "#{message.command_short_name} has completed.\nCommand: #{message.command}\nTime: #{message.time_string}\n"
      msg
    end

    def can_alert?
      rtn = true
      rtn &= options[:username]
      error_messages << "No :username option in config file" if !options[:username]
      rtn &= options[:password]
      error_messages << "No :password option in config file" if !options[:password]
      rtn &= options[:to]
      error_messages << "No :to option in config file" if !options[:to]
      rtn
    end
  end
end
