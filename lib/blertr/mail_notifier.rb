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
      blert_user = "#{username}@gmail.com"
      password = options[:password]
      receiver = options[:to]
      msg = create_message(message, receiver, blert_user)
      smtp = Net::SMTP.new 'smtp.gmail.com', 587
      smtp.enable_starttls
      smtp.start('smtp.gmail.com', blert_user, password, :plain) do
        smtp.send_message(msg, blert_user, receiver)
      end
    end

    def create_message message, to, from
      date = Time.now.strftime("%a, %d %b %Y %H:%M:%S %z")
      msg = "Date: #{date}\n"
      msg += "From: Blertr App <#{from}>\n"
      msg += "To: #{to} <#{to}>\n"
      msg += "Subject: #{message.command_short_name} is done!\n"
      msg += "\n"
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
