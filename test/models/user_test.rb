require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
  	@user = User.new(name: "Example User", email: "example@framgia.com",
                                           password: "123456",
                                           password_confirmation: "123456"  )
  end

  test "should be valid" do
  	assert @user.valid?
  end

  test "name should be presence" do
  	@user.name = "   "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = "a" * 51
  	assert_not @user.valid?
  end

  test "name should not be too short" do
  	@user.name = "a"
  	assert_not @user.valid?
  end

  test "email should be presence" do
  	@user.email = "   "
  	assert_not @user.valid?
  end

  test "email should not be too long" do
  	@user.email = "a" * 101
  	assert_not @user.valid?
  end

  test "email should not be too short" do
  	@user.email = "a"
  	assert_not @user.valid?
  end

  test 'email should reject invalid addresses' do
    invalid_addresses = %w[user@example user@example,com user@user+example.com user@user_email.com ]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email should be uniqueness" do
    clone_user = @user.dup
    clone_user.email = @user.email.upcase
    @user.save
    assert_not clone_user.valid?
  end

  test "password should not be too short" do
    @user.password = "a"
    @user.password_confirmation = "a"
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @user.save
    @user.entries.create!(title: "another status", body: "Lorem ipsum")
    assert_difference 'Entry.count', -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    michael = users(:michael)
    archer  = users(:archer)
    assert_not michael.following?(archer)
    michael.follow(archer)
    assert michael.following?(archer)
    assert archer.followers.include?(michael)
    michael.unfollow(archer)
    assert_not michael.following?(archer)
  end

  test "feed should have the right posts" do
    michael = users(:michael)
    archer  = users(:archer)
    lana    = users(:lana)
    # Posts from followed user
    lana.entries.each do |post_following|
      assert michael.feed.include?(post_following)
    end
    # Posts from self
    michael.entries.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    archer.entries.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end
end
