require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  
  test "layouts link" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a.btn[href=?]", signup_path

    get signup_path
    assert_select "title", full_title("Sign up")
  end


end
