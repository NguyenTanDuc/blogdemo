require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  def setup
  	@user = users(:michael)
  	@entry = entries(:two)
  	@comment = Comment.new(content: "That's very nice",user_id: @user.id, entry_id: @entry.id)
  end

  test "should be valid" do
  	assert @comment.valid?
  end

  test "user id and entry id should be present" do
  	@comment.user_id = nil
  	@comment.entry_id = nil
  	assert_not @comment.valid?
  end

  test "content should not be too long" do
  	@comment.content = "a" * 257
  	assert_not @comment.valid?
  end

  test "order should be most recent first" do
  	assert_equal Comment.first, comments(:dislike)
  end

  test "associated comments should be destroyed when delete entry" do
  	@user.save
  	@entry.save
  	Comment.create!(content: "Should be",user_id: @user.id, entry_id: @entry.id)
  	assert_difference 'Comment.count', -1 do
  		@entry.destroy
  	end
  end

  test "associated comments should be destroyed when delete user" do
  	@user.save
  	@entry.save
  	Comment.create!(content: "Must be",user_id: @user.id, entry_id: @entry.id)
  	assert_difference 'Comment.count', -1 do
  		@user.destroy
  	end
  end
end
