require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new name: "Example user", email: "user@example.com" 
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be valid" do
    @user.name = '       '
    assert_not @user.valid?
  end

  test "email should be valid" do
    @user.email = '       '
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a"*256
    assert_not @user.valid?
  end

end
