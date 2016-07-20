require_relative '../test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  test "a user can login successfully" do
    user = User.create(username: "Zack", password: "password")

    visit login_path

    fill_in 'session[username]', with: "Zack"
    fill_in 'session[password]', with: "password"

    click_on("Log in")

    assert_equal user_path(user), current_path

    within("#greeting") do
      assert page.has_content?("Welcome, Zack")
    end
  end

  test "a user can't login with incorrect password" do
    user = User.create(username: "andrew", password: "password")

    visit login_path

    fill_in 'session[username]', with: 'andrew'
    fill_in 'session[password]', with: 'fassword'

    click_on("Log in")

    assert_equal login_path, current_path
    assert page.has_content? 'invalid login'
  end

  test "a user can logout" do
    user = User.create(username: "andrew", password: "password")
    ApplicationController.any_instance.stubs(:current_user).returns(user)

    assert page.has_content?("andrew")

    click_on "logout"

    assert_equal root_path, current_path
    refute page.has_content?("andrew")
  end
end
