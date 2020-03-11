require 'tty-prompt'

require_relative '../lib/account'
require_relative '../lib/mail_constant'
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
end