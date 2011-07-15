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
      msg += "#{message.command_short_name} has completed.\nFull Command: #{message.command}\nTime Taken: #{message.time_string}\n"
      msg
    end

    def can_alert?
      rtn = true
      rtn &= options[:username]
      rtn &= options[:password]
      rtn &= options[:to]
      rtn
    end
  end
end
