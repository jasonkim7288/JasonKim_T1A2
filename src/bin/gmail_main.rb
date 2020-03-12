require 'tty-prompt'
require 'gmail'

require_relative '../lib/account'
require_relative '../lib/mail_constant'
require_relative '../lib/gmail_manager'
require_relative 'screen_control'

include ScreenControl

my_account = Account.new
prompt = TTY::Prompt.new
goto_login = false;

loop do
    # Print the title and account
    system("clear")
    
    puts ScreenControl.title_to_string
    puts my_account.to_string

    # User input for Account menu
    choice_made_account = ScreenControl.prompt_account_options(my_account)
    case choice_made_account
    when 1  # Login with an existing account
        account_name = ScreenControl.get_account_name_from_select(my_account)
        passwd = ScreenControl.input_password
    when 2  # Login with another account
        account_name = ScreenControl.get_account_name_from_input
        passwd = ScreenControl.input_password
    when 3  # Remove an account
        account_name = ScreenControl.get_account_name_from_select(my_account)
        next if ScreenControl.ask_and_remove(my_account, account_name)
    when 4  # Exit
        puts ScreenControl.bye_to_string
        exit
    else
        ScreenControl.invalid_input
        next
    end

    puts "\nLogging in...."
    goto_login = false;

    loop do
        begin
            # Log in Gmail
            gmail = Gmail.connect(account_name + MailConstant::STR_POSTFIX_GMAIL, passwd) do |gmail|
                ScreenControl.start_hacking(gmail, account_name, passwd)
                my_gmail_manager = GmailManager.new(gmail)                
                goto_refresh = false;

                # Loop for mail list 
                loop do
                    puts "Loading the mail list..."

                    my_account.add(account_name) if !my_account.name.include?(account_name)
                    # Display mail list
                    my_gmail_manager.load_mail_box
                    str_mail_list = my_gmail_manager.mail_list_to_string
                    ScreenControl.display_mail_list(my_gmail_manager, account_name, str_mail_list)

                    # User input for mail list
                    choice_made_mail_list = ScreenControl.prompt_mail_list_options(my_gmail_manager)
                    case choice_made_mail_list
                    when 1  # Change label
                        my_gmail_manager.current_mail_label = prompt.enum_select("Which label would you like to go?", my_gmail_manager.mail_labels_array)
                        next
                    when 2  # View the mail
                        ScreenControl.prompt_mail_select(my_gmail_manager)

                        # Loop for mail detail
                        loop do
                            # Display mail detail
                            ScreenControl.display_mail_detail(my_gmail_manager, account_name)

                            #User input form mail detail
                            choice_made_mail_detail = ScreenControl.prompt_mail_detail_options
                            case choice_made_mail_detail
                            when 1  # Go back to the list
                                break
                            when 2  #Log out
                                goto_login = true
                                break
                            when 3  # Exit
                                puts ScreenControl.bye_to_string
                                exit
                            end
                        end
                    when 3  # Previous page
                        my_gmail_manager.goto_prev_page
                        next
                    when 4  # Next page
                        my_gmail_manager.goto_next_page
                        next
                    when 5  # Create a new mail
                        ScreenControl.create_new_mail(gmail)
                    when 6  # Refresh
                        goto_refresh = true;
                        break
                    when 7  # Log out
                        goto_login = true;
                        break
                    when 8  # Exit
                        puts ScreenControl.bye_to_string
                        exit
                    else
                    end
                end

                gmail.logout
                break if goto_login
            end

            if goto_login
                goto_login = false
                break
            end

            puts "Refreshing..."
        # Excption handling. If it happens, go to the account list
        rescue Errno::ECONNRESET
            ScreenControl.err_response(MailConstant::STR_ERR_CONNECTION_CLOSED)
            break
        rescue Net::IMAP::NoResponseError
            ScreenControl.err_response(MailConstant::STR_ERR_NO_RESPONSE)
            break
        rescue Net::IMAP::BadResponseError
            ScreenControl.err_response(MailConstant::STR_ERR_LOGIN_FAILED)
            break
        rescue Exception
            ScreenControl.err_response(MailConstant::STR_ERR_UNKNOWN)
            break
        end
    end
end