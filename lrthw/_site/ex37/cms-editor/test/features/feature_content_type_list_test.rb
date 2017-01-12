require 'test_helper'

# Test Content Items actions
class FeatureContentTypeListTest < Capybara::Rails::TestCase
  def test_display_team_profile
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('cms-test-user')

    # Set the session so we spoof being authenticated and don't reset permissions on page load
    page.set_rack_session(user_authenticated: true)

    visit content_type_list_path
    assert page.has_css?('table.content-types')

    content_type_titles = page.all('th.type-title').map(&:text)
    assert content_type_titles.include?('Team profile')
  end

  def test_display_user_orgs_only_content
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('cms-science-user')

    # Set the session so we spoof being authenticated and don't reset permissions on page load
    page.set_rack_session(user_authenticated: true)

    visit root_path
    assert page.has_content?('Science only item'), "Page doesn't have Science owned content"
    assert page.has_content?('Mar Comms owned item associated with Science'), "Page doesn't list item owned by MarComms but associated with Science"
    assert page.has_content?('Group owned item'), "Page doesn't list item owned by group"
    assert page.has_no_content?('Mar Comms only item'), 'Page is listing content for other orgs'
  end

  def test_user_in_parent_org_can_see_group_content
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('cms-parent-org-user')

    # Set the session so we spoof being authenticated and don't reset permissions on page load
    page.set_rack_session(user_authenticated: true)

    visit root_path
    assert page.has_content?('Corp info belonging to group'), "Page doesn't have item that belongs to child group"
  end

  def test_user_in_associated_parent_org_can_see_associated_group_content
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('cms-associated-parent-org-user')

    # Set the session so we spoof being authenticated and don't reset permissions on page load
    page.set_rack_session(user_authenticated: true)

    visit root_path
    assert page.has_content?('Corp info belonging to associated group of an associated org'), "Page doesn't have item that belongs to child group"
  end

  def test_user_in_parent_org_can_see_item_associated_to_child_group
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('cms_parent_org_user')

    # Set the session so we spoof being authenticated and don't reset permissions on page load
    page.set_rack_session(user_authenticated: true)

    visit root_path
    assert page.has_content?('Corp info belonging to associated group'),
           "Page doesn't have item that belongs to child group"
  end

  def test_role_holder_name_is_listed_for_person_profiles
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('cms-admin-user')

    # Set the session so we spoof being authenticated and don't reset permissions on page load
    page.set_rack_session(user_authenticated: true)

    # Pagination workaround: save the content item so it goes to the top of the list
    person_profile = person_profiles(:for_test_role_holder_name_is_listed_for_person_profiles)
    content_item = content_items(:for_test_role_holder_name_is_listed_for_person_profiles_content_item)
    visit edit_person_profile_path(person_profile.id)
    click_button(I18n.t('shared.status_buttons.save_close'))

    visit root_path
    assert page.has_content?("#{person_profile.role_holder_name} – #{content_item.title}"),
           "Page doesn't include role holder name"
  end
end
