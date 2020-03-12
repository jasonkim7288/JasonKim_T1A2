require 'test/unit'
require_relative '../lib/gmail_manager'

class GmailTest
    attr_accessor :labels_inside
    def initialize
        @labels_inside = ["Inbox", "Outbox", "Bin"]
        @emails = ["email_1", "email_2", "email_3", "email_4", "email_5", "email_6", "email_7", "email_8", "email_9", "email_10",]
    end
    def mailbox(labels)
        return self
    end
    def emails(label)
        return @emails
    end
    def labels
        return self
    end
    def all
        return @labels_inside
    end
end

# Test for GmailManager
class GmailManagerTest < Test::Unit::TestCase
    def setup
        gmail = GmailTest.new
        @gmail_manager = GmailManager.new(gmail)
        @gmail_manager.load_mail_box
    end

    # Test about going to previous page in the mail list
    def test_goto_prev_page
        @gmail_manager.current_page = 2
        
        # If current page is 2 and go to previous page, current page has to be 1
        @gmail_manager.goto_prev_page
        assert_equal(1, @gmail_manager.current_page)

        # If current page is 1 and go to previous page, current page has not to be changed
        @gmail_manager.goto_prev_page
        assert_equal(1, @gmail_manager.current_page)
    end

    # Test about going to next page in the mail list
    def test_goto_next_page
        @gmail_manager.current_page = 1

        # If current page is 1 and go to next page, current page has to be 2
        @gmail_manager.goto_next_page
        assert_equal(2, @gmail_manager.current_page)

        # If current page is 2 and go to next page, current page has not to be changed
        @gmail_manager.goto_next_page
        assert_equal(2, @gmail_manager.current_page)
    end
end