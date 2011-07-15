require 'blertr/notifier'

module Blertr
  class GrowlNotifier < Notifier
    def initialize
      super
      @names = ["growl"]
    end

    def alert message
      #TODO: look to supporting other growl frameworks on other OSs
      system("growlnotify -n \"Terminal\" -m \"took #{message.time_string}\" \"#{message.command}\"")
    end

    def can_alert?
      results = %x[which growlnotify]
      !results.nil? and !results.empty?
    end
  end
end
