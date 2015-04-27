require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
	end

	test "Login with invalid information" do
		get login_users_path
		assert_template "sessions/new"  	
		post login_users_path, session: { email: "wrong@exam", password: "123456" }
		assert_template "sessions/new"
		assert_not flash.empty?
		get login_users_path
		assert flash.empty?
	end

	test "Login with valid information and logout" do
		get login_users_path
		post login_users_path, session: { email: @user.email, password: "123456" }
		assert is_logged_in?
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		assert_select "a[href=?]", login_users_path, count: 0
		assert_select "a[href=?]", root_path
		assert_select "a[href=?]", logout_users_path
		delete logout_users_path
	    assert_not is_logged_in?
	    assert_redirected_to root_url
	    delete logout_users_path
	    follow_redirect!
	    assert_select "a[href=?]", login_users_path
	    assert_select "a[href=?]", logout_users_path,      count: 0
	end

	test "login with remembering" do
	    log_in_as(@user, remember_me: '1')
	    assert_not_nil cookies['remember_token']
    end

	test "login without remembering" do
		log_in_as(@user, remember_me: '0')
		assert_nil cookies['remember_token']
	end
end
