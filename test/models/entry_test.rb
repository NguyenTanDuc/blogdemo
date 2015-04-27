require 'test_helper'

class EntryTest < ActiveSupport::TestCase
  def setup
  	@user = users(:michael)
  	@entry = @user.entries.build(title: "titlerino", body: "Lorem bla bla bla")
  end

  test "should be valid" do
  	assert @entry.valid?
  end

  test "user id should be present" do
  	@entry.user_id = nil
  	assert_not @entry.valid?
  end

  test "title should be present" do
  	@entry.title = "   "
  	assert_not @entry.valid?
  end

  test "title should not be too long" do
  	@entry.title = "a" * 257
  	assert_not @entry.valid?
  end

  test "body should be present" do
  	@entry.body = "   "
  	assert_not @entry.valid?
  end

  test "body should not be too long" do
  	@entry.body = "a" * 1025
  	assert_not @entry.valid?
  end
  
  test "order should be DESC " do
  	assert_equal Entry.first, entries(:most_recent)
  end
end
