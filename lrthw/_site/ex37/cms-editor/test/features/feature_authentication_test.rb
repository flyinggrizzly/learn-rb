require 'test_helper'

# Test authentication
class AuthenticationTest < Capybara::Rails::TestCase
  def setup
    # Use a known admin here
    CASClient::Frameworks::Rails::Filter.fake('if243')
  end

  def test_log_in_admin
    visit root_path

    # Now fetch the user and see what permissions they have
    user = User.find_by(username: page.get_rack_session_key('cas_user'))
    assert user.admin?, 'User should be an admin'
  end

  def test_admin_drop_permissions_to_editor
    visit root_path + '?set-role=editor'

    # Now fetch the user and see what permissions they have
    user = User.find_by(username: page.get_rack_session_key('cas_user'))
    refute user.admin?, 'User should not be an admin'
    assert user.editor?, 'User should be an editor'
  end

  def test_admin_drop_permissions_to_author
    visit root_path + '?set-role=author'

    # Now fetch the user and see what permissions they have
    user = User.find_by(username: page.get_rack_session_key('cas_user'))
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    assert user.author?, 'User should be an author'
  end

  def test_admin_drop_permissions_to_contributor
    visit root_path + '?set-role=contributor'

    # Now fetch the user and see what permissions they have
    user = User.find_by(username: page.get_rack_session_key('cas_user'))
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    assert user.contributor?, 'User should be a contributor'
  end

  def test_user_no_permissions
    # User with no permission to access the application
    CASClient::Frameworks::Rails::Filter.fake('ccsgtm')
    visit root_path

    # Check we are on the permission denied page
    assert_equal url_for(controller: :error, action: :no_permissions, only_path: true), page.current_path

    # Now fetch the user and see what permissions they have
    user = User.find_by(username: page.get_rack_session_key('cas_user'))
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    refute user.contributor?, 'User should not be a contributor'
  end
end
