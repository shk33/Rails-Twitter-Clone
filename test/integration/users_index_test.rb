require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_user = User.paginate(page: 1)

    #Check all users have the delete link except the admin
    first_page_user.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete',
                                                    method: :delete
      end
    end

    #Delete the non admin user
    assert_difference 'User.count', -1 do
      delete user_path @non_admin
    end
  end

  test "index as non_admin" do
    log_in_as @non_admin
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end
