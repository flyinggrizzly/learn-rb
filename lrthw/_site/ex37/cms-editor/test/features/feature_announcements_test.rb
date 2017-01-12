require 'test_helper'

# Test Announcement actions
class FeatureAnnouncementTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_new_announcement
    visit new_announcement_path

    assert page.has_content?('New announcement'), 'Screen for creating a new announcement not rendered properly'

    assert fill_in('announcement_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('announcement_content_item_attributes_i_need', with: 'to create an announcement'), "Couldn't set i_need field"
    assert fill_in('announcement_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('announcement_content_item_attributes_title', with: 'Brand new announcement'), "Couldn't set title field"
    assert fill_in('announcement_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"

    assert choose('announcement_subtype_news_story'), 'Could not choose news story subtype'
    assert fill_in('announcement_body_content', with: 'Blah blah blah'), "Couldn't fill in body content"
    assert choose('announcement_call_to_action_type_url'), 'Could not choose url CTA type'
    assert fill_in('announcement_call_to_action_label', with: 'Start'), "Couldn't set a CTA label"
    assert fill_in('announcement_call_to_action_content', with: 'http://www.google.com'), "Couldn't set a CTA URL"

    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_announcement
    visit delete_path
    assert page.has_content?('For test deletion announcement'), 'Announcement to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_announcement_content_item).id
    announcement_id = announcements(:for_test_deletion_announcement).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Announcement.find(announcement_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion announcement'), 'Announcement not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Announcement.find(announcement_id) }
  end

  def test_internal_url
    announcement = announcements(:internal_cta_announcement)
    visit edit_announcement_path(announcement.id)

    assert page.has_content?('Editing announcement'), 'Screen for editing an announcement not rendered properly'

    # Test an internal URL which doesn't exist
    assert fill_in('announcement_call_to_action_content', with: 'http://staging-beta.bath.ac.uk/announcements/this-doesnt-exist/'),
           "Couldn't set call_to_action_content field"
    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal "/announcements/#{announcement.id}", page.current_path, 'Validations should have been triggered'

    # Test an internal URL which does exist
    assert fill_in('announcement_call_to_action_content', with: 'http://staging-beta.bath.ac.uk/announcements/internal-url-announcement/'),
           "Couldn't set call_to_action_content field"
    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.published_save')), 'Saving did not complete properly'

    # Check that the protocol and host have been stripped off the url
    visit edit_announcement_path(announcement.id)
    assert_equal '/announcements/internal-url-announcement/', page.find('#announcement_call_to_action_content').value
  end

  def test_status_does_not_change_on_validation_error
    announcement = announcements(:test_status_does_not_change_on_validation_error_announcement)
    visit edit_announcement_path(announcement.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert assert fill_in('announcement_call_to_action_content', with: 'Blah blah blah'), "Couldn't fill in Call to Action URL"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
