class MailConstant
    CHOICES_ACCOUNT = {"Login with an existing account" => 1, "Login with another account" => 2, "Remove an account" => 3, "Exit" => 4}.freeze
    STR_NORMAL_QUESTION = "What would you like to do?".freeze
    STR_INPUT_ACCOUNT_NAME = "Please input Gmail account name without '@gmail.com': "
    STR_POSTFIX_GMAIL = "@gmail.com"
    STR_ACCOUNT_LIST_EMPTY = "Account list is empty"


    NUM_OF_ROWS_PREVIEW = 7.freeze
    FILE_NAME_ACCOUNT = "../account.db".freeze
    COLUMN_CENTER_WIDTH = 119.freeze
    COLUMN_MAIL_LIST_NO_SIZE = 7.freeze
    COLUMN_MAIL_LIST_FROM_SIZE = 29.freeze
    COLUMN_MAIL_LIST_CONTENT_SIZE = 74.freeze
    COLUMN_MAIL_DETAIL_HEADER_SIZE = 9.freeze
    COLUMN_MAIL_DETAIL_CONTENT_SIZE = 104.freeze
end