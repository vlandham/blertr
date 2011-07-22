
require 'blertr/notifier'

module Blertr
  class TwitterNotifier < Notifier
    def initialize
      super
      @names = ["twitter", "tweet", "twit"]
    end

    def alert message
      Twitter.configure do |config|
        config.consumer_key = options[:consumer_key]
        config.consumer_secret = options[:consumer_secret]
        config.oauth_token = options[:oauth_token]
        config.oauth_token_secret = options[:oauth_token_secret]
      end
      msg = message message.command_short_name, command.time_string
      Twitter.update(msg)
    end

    def message name, time
      user = options[:to].nil? ? "" : "@#{options[:to]}"
      msg = "#{user} #{name} is done! Took #{time}"
      msg
    end

    def can_alert?
      rtn = true
      begin
        require 'rubygems'
        require 'twitter'
      rescue LoadError => e
        rtn = false
        error_messages << "twitter gem cannot be found"
      end
      if rtn
        [:consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret].each do |key|
          rtn &= options[key]
          error_messages << "No #{key} in config file"
        end
      end
      rtn
    end
  end
end
