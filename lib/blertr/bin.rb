
require 'blertr'

module Blertr
  class Bin

    def self.add_services services, time
      puts services
    end

    def self.help
  help_string = <<EOS
-=[ Welcome to Blertr - Notifications for Bash commands ]=-

Usage: blertr [command] [command parameters]

Commands:
    help       Output this help message

    install    Add symlinks to your system to allow
               Blertr to function properly

    uninstall  Remove symlinks and other setup process
               Effectively uninstalling Blertr

    upgrade    Updates current copy of blertr to latest version
    
    info       Pass in a notifier name to get the 
               information it is using to send notifications
               Example: blertr info email

    status     For each notifier, Blertr lists if it currently can
               send notifications and then lists any error messages
               if it cannot. Useful for debuggin problems with notifiers

    exclude    Pass in a shell command to prevent Blertr from
               sending notifications when that command is 
               executed
               Example: blertr exclude ssh
   
    time       Pass in a notifier name and a time string to
               set the time required to pass before the
               notifier sends a message for a command
               Example: blertr time email 5 minutes
               This would make blertr send an email only if
               the command executing took longer than 5 mins

    set        Pass in the notifier name, a configuration key, and
               a value. Blertr will add this key / value to the 
               notifiers config file.
               Example: blertr set mail to user@gmail.com
EOS
  puts help_string
    end

    def self.take_action action, parameters
      parameters = [parameters].flatten.compact
      blertr_path = File.expand_path(File.join(File.dirname(__FILE__), ".."))
      blertr_local_dir = File.expand_path("~/.blertr")
      blertr_symlink = File.join(blertr_local_dir, "app")
      case action
      when "help",nil
        help
      when "install"
        if File.exists? blertr_symlink
          puts "ERROR: Blertr appears to already be installed.\nUninstall with blertr uninstall"
        else
          puts "creating #{blertr_local_dir} directory"
          system("mkdir -p #{blertr_local_dir}")

          puts "creating symlink from #{blertr_path} to #{blertr_symlink}"
          system("ln -s #{blertr_path} #{blertr_symlink}")

          config_dir = File.expand_path(Blertr::CONFIG_DIR_PATH)
          if !File.exists?(config_dir)
            blertr_config_dir = File.expand_path(File.join(File.dirname(__FILE__), "..", "config"))
            puts "copying config files to #{blertr_path}"
            system("cp -r #{blertr_config_dir} #{blertr_local_dir}")
          end
          puts "Blertr is now (almost) installed!\nPut this at the bottom of your .bashrc file:"
          puts "[[ -s \"$HOME/.blertr/app/scripts/blertr\" ]] && . \"$HOME/.blertr/app/scripts/blertr\""
        end
      when "uninstall"
        if File.exists? blertr_symlink
          puts "Removing #{blertr_symlink}"
          system("rm #{blertr_symlink}")
          puts "Blertr is now (almost) uninstalled.\nRemove from .bashrc file:"
          puts "[[ -s \"$HOME/.blertr/scripts/blertr\" ]] && . \"$HOME/.blertr/scripts/blertr\""
        else
          puts "ERROR: it doesn't look like Blertr is installed"
        end
      when "upgrade"
        commands = ["gem install blertr", "blertr uninstall", "blertr install"]
        puts "Right now the upgrade process is very basic. Blertr will run:"
        commands.each {|c| puts "$ #{c}"}
        puts "This assumes that blertr is installed using rvm and doesn't require"
        puts " sudo access."
        puts "That ok? (y/n)"
        response = gets
        if ["y","Y","yes","Yes","YES"].include?(response.chomp)
          puts "Ok, running commands now."
          commands.each {|c| system(c)}
        else
          puts "You're the boss, exiting now."
        end
      when "info"
        raw_name = parameters.shift
        raw_name = raw_name ? raw_name.strip : nil
        raw_name = (raw_name and raw_name.empty?) ? nil : raw_name

        names = []
        if !raw_name
          Blertr::Control::notifiers.each { |notifier| names << notifier.name}
        else
          if Blertr::Control::is_notifier? raw_name
            names << Blertr::Control::notifier_with_name(raw_name).name
          else
            puts "Error: #{raw_name} is not a notifier"
            puts "use blertr status to list all notifiers"
          end
        end

        names.each do |name|
          info_hash = Blertr::Options.options_for name
          puts "Configuration for: #{name}"
          if info_hash.empty?
            puts "     No configuration file for #{name} or config file is empty"
          else
            info_hash.each do |key,value|
              puts "     #{key}: #{value}"
            end
          end
        end
      when "status"
        Blertr::Control::notifiers.each do |notifier|
          notify_message = notifier.can_alert? ? "can alert" : "cannot alert"
          puts "#{notifier.name}: #{notify_message}"
          if !notifier.error_messages.empty?
            notifier.error_messages.each {|err| puts "  #{err}"}
          end
        end
      when "exclude"
        name = parameters.join(" ").strip
        unless !name or name.empty?
          puts "Excluding #{name} from Blertr alerts"
          Blertr::Blacklist.new.add(name)
        else
          puts "Error: excluding requires a command to exclude"
          puts "Example: blertr exclude ssh"
        end
      when "set"
        notifier_name = parameters.shift
        if Blertr::Control::is_notifier? notifier_name
          key = parameters.shift
          value = parameters.shift
          if key and value
            puts "Setting #{notifier_name}'s #{key} to #{value}"
            Blertr::Control::notifier_with_name(notifier_name).set_option(key,value)
          else
            puts "Error: set command requires a key and a value to set it to"
            puts "Example: blertr set email to user@gmail.com"
          end
        else
          puts "Error: #{notifier_name} isn't a notifier."
          puts "Use blertr status for a list of all notifiers"
        end
      when "time"
        if !parameters.empty?
          notifier_found = false
          notifiers = parameters.shift.strip.split(",")
          notifiers.each do |notifier|
            if Blertr::Control::is_notifier? notifier
              notifier_found = true
              new_time = parameters.join(" ").strip
              unless new_time.empty?
                Blertr::Control::change_time notifier, new_time
              else
                puts "Error: setting time requires a new time"
                puts "Example: blertr time #{notifier} 5 minutes"
              end
            end
          end

          if !notifier_found
            puts "Sorry, #{notifiers.join(",")} isn't a notifier."
            puts "Use blertr status for a list of all notifiers"
            puts "Example: blertr time mail 5 minutes"
          end
        else
          puts "All Notifier Times:"
          Blertr::Control::notifiers.each do |notifier|
            notifier_time = "#{notifier.name}".ljust(20)
            notifier_time += notifier.options[:time] ? "#{notifier.options[:time]} seconds" : "not set"
            puts notifier_time
          end
          puts ""
          puts "Use blertr time [notifier] [time]"
          puts " to set time for notifier."
          puts "Example: blertr time mail 5 minutes"
        end
      else
        puts "Sorry, #{action} isn't a recognized command"
        puts "use blertr help to get a list of availible commands."
      end
    end
  end
end
