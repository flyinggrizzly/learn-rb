require 'test_helper'

# Test authorization
class AdminSectionAuthorizationTest < Capybara::Rails::TestCase
  def setup
    # Use a known admin here
    CASClient::Frameworks::Rails::Filter.fake('if243')
    # Use webkit and block unknown urls
    Capybara.current_driver = :webkit
    Capybara.page.driver.block_unknown_urls
  end

  def test_admin_access_users
    visit users_path
    assert page.has_content?('Listing Users'), 'Not on the user listing page'

    visit new_user_path
    assert page.has_content?('New User'), 'Not on the new user page'
  end

  def test_editor_no_access_users
    # drop permissions to editor
    visit root_path + '?set-role=editor'

    visit users_path
    # should end up on the permission denied page
    assert_equal url_for(controller: :error, action: :no_permissions, only_path: true), page.current_path

    visit new_user_path
    # should end up on the permission denied page
    assert_equal url_for(controller: :error, action: :no_permissions, only_path: true), page.current_path
  end

  def test_admin_access_organisations
    visit organisations_path
    assert page.has_content?('Listing Organisations'), 'Not on the org listing page'

    visit new_organisation_path
    assert page.has_content?('New Organisation'), 'Not on the new org page'
  end

  def test_editor_no_access_organisations
    # drop permissions to editor
    visit root_path + '?set-role=editor'

    visit organisations_path
    # should end up on the permission denied page
    assert_equal url_for(controller: :error, action: :no_permissions, only_path: true), page.current_path

    visit new_organisation_path
    # should end up on the permission denied page
    assert_equal url_for(controller: :error, action: :no_permissions, only_path: true), page.current_path
  end

  def test_admin_access_delete
    visit delete_path
    assert page.has_content?('Delete content items'), 'Not on the user listing page'
  end

  def test_editor_no_access_delete
    # drop permissions to editor
    visit root_path + '?set-role=editor'

    visit delete_path
    # should end up on the permission denied page
    assert_equal url_for(controller: :error, action: :no_permissions, only_path: true), page.current_path
  end
end
