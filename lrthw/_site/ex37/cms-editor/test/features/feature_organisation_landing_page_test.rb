require 'test_helper'

# Test Announcement actions
class FeatureOrganisationLandingPageTest < Capybara::Rails::TestCase
  def setup_as_admin
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def setup_as_non_admin
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('rg373')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_new_organisation_landing_page
    setup_as_admin

    visit new_organisation_landing_page_path

    assert page.has_content?('New landing page'),
           'Screen for creating a new organisation_landing_page not rendered properly'

    assert choose('organisation_landing_page_subtype_organisation'), 'Could not choose Organisation subtype'
    assert fill_in('organisation_landing_page_content_item_attributes_as_a', with: 'Testing robot'),
           "Couldn't set as_a field"
    assert fill_in('organisation_landing_page_content_item_attributes_i_need',
                   with: 'to create an organisation_landing_page'), "Couldn't set i_need field"
    assert fill_in('organisation_landing_page_content_item_attributes_so_that',
                   with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('organisation_landing_page_content_item_attributes_title',
                   with: 'Brand new organisation_landing_page'), "Couldn't set title field"
    assert fill_in('organisation_landing_page_content_item_attributes_summary', with: 'blah'),
           "Couldn't set summary field"

    assert fill_in('organisation_landing_page_about', with: 'Organisation about text'), "Couldn't fill in about"
    assert choose('organisation_landing_page_content_list_groups'), 'Could not choose Groups content_list'
    assert choose('organisation_landing_page_on_off_campus_on_campus'), 'Could not choose campus on_off_campus'
    assert fill_in('organisation_landing_page_building', with: 'Wessex House'), "Couldn't fill in building"
    assert fill_in('organisation_landing_page_room', with: '4.16'), "Couldn't fill in room"

    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_organisation_landing_page
    setup_as_admin

    visit delete_path
    assert page.has_content?('For test deletion org landing page'), 'Organisation landing page to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_organisation_landing_page_content_item).id
    organisation_landing_page_id = organisation_landing_pages(:for_test_deletion_organisation_landing_page).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil OrganisationLandingPage.find(organisation_landing_page_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion org landing page'), 'Organisation landing page not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { OrganisationLandingPage.find(organisation_landing_page_id) }
  end

  def test_non_admin_cant_edit_content_item
    setup_as_non_admin

    org = organisation_landing_pages(:test_non_admin_cant_edit_content_item_feature)
    visit edit_organisation_landing_page_path(org)

    assert_includes page.html, I18n.t('shared.content_item_display_only.no_permission_html'),
                    'User should see permission denied message'
    assert page.has_no_field?('organisation_landing_page_content_item_attributes_as_a'),
           'User should not be able to edit content item fields'
    assert page.has_no_field?('organisation_landing_page[content_item_attributes][organisation_id]'),
           'User should not be able to set owning org'

    assert click_button(I18n.t('shared.status_buttons.save_close'))
    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_status_does_not_change_on_validation_error
    setup_as_admin
    org_landing_page = organisation_landing_pages(:test_status_does_not_change_on_validation_error_org_landing_page)
    visit edit_organisation_landing_page_path(org_landing_page.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert fill_in('organisation_landing_page_contact_email', with: 'Blah blah blah'),
           "Couldn't fill in Contact email"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
