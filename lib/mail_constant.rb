class MailConstant
    STR_NORMAL_QUESTION = "What would you like to do?".freeze
    STR_INPUT_ACCOUNT_NAME = "Please input Gmail account name without '@gmail.com': ".freeze
    STR_POSTFIX_GMAIL = "@gmail.com".freeze
    STR_ACCOUNT_LIST_EMPTY = "Account list is empty".freeze
    STR_ERR_CONNECTION_CLOSED = "Connection is closed. Please log in again".freeze
    STR_ERR_NO_RESPONSE = "No response for the command. Please log in again".freeze
    STR_ERR_LOGIN_FAILED = "Log in failed. Please log in again".freeze
    STR_ERR_UNKNOWN = "Unknown error. Please log in again".freeze
    STR_MAILBOX_EMPTY = "Mailbox is empty".freeze

    CHOICES_MAIL_DETAIL = {"Go back to the list" => 1, "Log out" => 2, "Exit" => 3}.freeze
    
    NUM_OF_ROWS_PREVIEW = 7.freeze
    FILE_NAME_ACCOUNT = "../account.db".freeze
    COLUMN_CENTER_WIDTH = 119.freeze
    COLUMN_MAIL_LIST_NO_SIZE = 7.freeze
    COLUMN_MAIL_LIST_FROM_SIZE = 29.freeze
    COLUMN_MAIL_LIST_CONTENT_SIZE = 74.freeze
    COLUMN_MAIL_DETAIL_HEADER_SIZE = 9.freeze
    COLUMN_MAIL_DETAIL_CONTENT_SIZE = 104.freeze
end