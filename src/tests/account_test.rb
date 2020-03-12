require 'test/unit'

require_relative '../lib/account'

# Test for Account class
class AccountTest < Test::Unit::TestCase
    def setup
        @account = Account.new
        @account.remove_all
    end

    # Test about adding account list
    def test_add
        # The normal Gmail ID should be stored into a file
        @account.add("jason.kim7288")
        @account.add("imjungseob.kim")
        @account.reload
        assert_equal(["jason.kim7288", "imjungseob.kim"], @account.name)

        # If an improper Gmail ID is input, account name list will not change
        @account.add("i am Jason")
        assert_equal(["jason.kim7288", "imjungseob.kim"], @account.name)
    end

    # Test about removing account list
    def test_delete
        @account.add("jason.kim7288")
        @account.add("imjungseob.kim")

        # If you try to remove Gmail ID which exists in the file, it will succeed
        @account.remove("jason.kim7288")
        @account.reload
        assert_equal(["imjungseob.kim"], @account.name)

        # If you try to remove Gmail ID which doesn't exist in the file, there will be no change
        @account.remove("hellosub")
        assert_equal(["imjungseob.kim"], @account.name)
    end
end