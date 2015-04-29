require 'test_helper'

class CommentsControllerTest < ActionController::TestCase

  def setup
  	@comment = comments(:unlike)
  end

  test "should redirect create when not logged in" do
  	assert_no_difference 'Comment.count' do
  		post :create, comment: { content: "This is cm"}
  	end
  	assert_redirected_to login_users_path
  end

  test "should redirect delete when not logged in" do
  	assert_no_difference 'Comment.count' do
  		post :destroy, id: @comment
  	end
  	assert_redirected_to login_users_path
  end

  test "should redirect destroy for wrong comment" do
    log_in_as(users(:michael))
    assert_no_difference 'Comment.count' do
      post :destroy, id: @comment
      assert_redirected_to root_path
    end
  end
end
