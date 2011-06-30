
require 'blertr/notifier'
require 'twitter'

module Blertr
  class TwitterNotifier < Notifier
    def initialize
      super
      @name = "twitter"
    end

    def alert name, time
      Twitter.configure do |config|
        config.consumer_key = options[:consumer_key]
        config.consumer_secret = options[:consumer_secret]
        config.oauth_token = options[:oauth_token]
        config.oauth_token_secret = options[:oauth_token_secret]
      end
      first_name = name.split(" ")[0]
      msg = message first_name, time
      Twitter.update(msg)
    end

    def message name, time
      user = options[:to].nil? ? "" : "@#{options[:to]}"
      msg = "#{user} #{name} is done! Took #{time} secs"
      msg
    end

    def can_alert?
      rtn = true
      [:consumer_key, :consumer_secret, :oauth_token, :oauth_token_secret].each { |key| rtn &= options[key]}
      rtn
    end
  end
end
