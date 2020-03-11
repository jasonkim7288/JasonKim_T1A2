require 'tty-font'
require 'pastel'
require 'colorize'
require_relative '../lib/mail_constant'

module ScreenControl
    @@font_standard = TTY::Font.new(:doom)
    @@font_doom = TTY::Font.new(:straight)
    @@pastel = Pastel.new
    @@prompt = TTY::Prompt.new

    def title_to_string
        return @@pastel.red(@@font_standard.write("     Gmail", letter_spacing: 4)) + " by Jason"
    end

    def current_user_to_string(account_name)
        return " Current User : #{account_name}\n\n\n"
    end

    def bye_to_string
        return @@pastel.blue(@@font_standard.write("Bye", letter_spacing: 2))
    end

    def get_account_name_from_select(account)
        return account.name[@@prompt.ask("Input the account number: 1~#{account.name.length}?") {|q| q.in("1-#{account.name.length}")}.to_i - 1]
    end

    def input_password
        print "Input password : "
        return STDIN.noecho(&:gets).chomp
    end

    def get_account_name_from_input
        print MailConstant::STR_INPUT_ACCOUNT_NAME
        return gets.chomp.downcase.gsub(MailConstant::STR_POSTFIX_GMAIL, "")
    end

    def ask_and_remove(account, account_name)
        if @@prompt.yes?("Do you really want to remove the accout \"#{account_name}\"?")
            puts "accout \"#{account_name}\" has been DELETED."
            account.remove(account_name)
            @@prompt.keypress("\nPress space or enter to continue", keys: [:space, :return])
            return true
        end
    end

    def invalid_input
        puts "Invalid input"
        @@prompt.keypress("\nPress space or enter to continue", keys: [:space, :return])
    end

    def prompt_account_options(account)
        @@prompt.enum_select(MailConstant::STR_NORMAL_QUESTION) do |menu|
            account.name.empty? ? (menu.choice "Login with an existing account", 1, disabled: "(N/A)") : (menu.choice "Login with an existing account", 1)
            menu.choice "Login with another account", 2
            account.name.empty? ? (menu.choice "Remove an account", 3, disabled: "(N/A)") : (menu.choice "Remove an account", 3)
            menu.choice "Exit", 4
        end
    end

    def err_response(message)
        puts message
        @@prompt.keypress("\nPress space or enter to continue", keys: [:space, :return])
    end

    def display_mail_list(gmail_manager, account_name, str_mail_list)
        system("clear")
        puts ScreenControl.title_to_string
        puts ScreenControl.current_user_to_string(account_name)
        puts gmail_manager.current_mail_label_to_string
        #puts str_mail_list
        #puts gmail_manager.pages_info_to_string
    end

    
end