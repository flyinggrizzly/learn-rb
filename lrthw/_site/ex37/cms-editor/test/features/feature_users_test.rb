require 'test_helper'

# Test Content Items actions
class FeatureUsersTest < Capybara::Rails::TestCase
  def setup
    # Have to test with a real person as cms-test-user doesn't come up in Person Finder
    CASClient::Frameworks::Rails::Filter.fake('rwp22')
  end

  def test_display_user_after_login
    visit users_path
    users_list = page.all('#users td').map(&:text)
    refute users_list.blank?, 'Page not displaying users'

    # Test displaying existing user from fixture
    assert users_list.include?('CMS Test User'), 'Page not not displaying CMS Test User'
    assert page.has_link?('CMS Test User'), 'Page not displaying link to Person Finder for cms-test-user'

    # Test new user who just logged in
    assert users_list.include?('Richard Prowse'), 'Page not displaying newly created user who just logged in'
    assert page.has_link?('Richard Prowse')
  end

  def test_user_added_to_org_on_login
    visit users_path
    org = User.find_by(username: 'rwp22').organisation
    refute org.blank?
    assert_equal organisations(:university_of_bath).name, org.name
  end

  def test_change_org_for_user
    visit users_path
    user = users(:cms_admin_user)
    assert_equal user.organisation.name, 'University of Bath'
    click_link('CMS Admin User')
    assert page.has_css?('#user_username[value="cms-admin-user"]')
    assert select('Department of Marketing and Communications', from: 'user[organisation_id]')
    click_button('Update User')

    # Get the changed value in the db, not the value defined in the fixture
    user = User.find_by_username('cms-admin-user')
    assert_equal user.organisation.name, 'Department of Marketing and Communications'
  end

  def test_add_author_to_associated_orgs
    visit users_path
    user = users(:cms_admin_user)
    assert user.associated_orgs.blank?

    click_link('CMS Admin User')
    assert select(organisations(:research_group).name, from: 'user[associated_org_ids][]')
    assert select(organisations(:science).name, from: 'user[associated_org_ids][]')
    click_button('Update User')

    user = User.find_by_username('cms-admin-user')
    refute user.associated_orgs.blank?
    assert user.associated_orgs.include?(organisations(:science))
  end

  def test_author_cannot_associate_with_org
    visit users_path
    user = users('cms_test_user_without_associated_org')
    refute user.editor?
    assert user.associated_orgs.blank?

    click_link('CMS Test User2')

    assert page.has_no_content?('Associated organisation')
    assert page.has_no_selector?('#user_associated_org_ids')
  end

  def test_editor_be_associated
    visit users_path
    user = users('cms_test_editor')
    assert user.editor?

    click_link('CMS Test Editor')

    assert page.has_content?('Associated organisation')
    assert select(organisations(:research_group).name, from: 'user[associated_org_ids][]')
    assert select(organisations(:science).name, from: 'user[associated_org_ids][]')
    click_button('Update User')
  end

  def test_users_ordered_by_display_name
    # assign the users
    user_aa_display_name = users(:ordering_test_user_aa).display_name
    user_bb_display_name = users(:ordering_test_user_bb).display_name
    user_zz_display_name = users(:ordering_test_user_zz).display_name

    visit users_path
    # check if the page content includes the display names of user_aa, user_bb and user_zz, in that order
    assert page.has_content?(/(#{user_aa_display_name}).*(#{user_bb_display_name}).*(#{user_zz_display_name})/), "Users aren't ordered alphabetically by display name"
  end
end
