require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  def setup
    @entry = entries(:two)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Entry.count' do
      post :create, entry: { title: "titlerino", body: "Lorem ipsum" }
    end
    assert_redirected_to login_users_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Entry.count' do
      delete :destroy, id: @entry
    end
    assert_redirected_to login_users_url
  end
end
