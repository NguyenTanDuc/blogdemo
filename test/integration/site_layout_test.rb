require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "Layout links" do
  	get root_path
  	assert_template 'home/index'
  	assert_select "a[href=?]", root_path
  	assert_select "a[href=?]", login_users_path
  end
end
