require 'test_helper'

# Test Person Profile actions
class FeatureEventTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_new_event
    Capybara.current_driver = :webkit

    visit new_event_path

    # fill in required Content Item fields using field ID
    assert choose('event_subtype_conferences'), "Couldn't choose conferences subtype"
    assert fill_in('event_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('event_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('event_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('event_content_item_attributes_title', with: 'test_add_new_event'), "Couldn't set title field"
    assert fill_in('event_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    # fill in required Event fields using field ID
    find('#event_start_3i').find(:xpath, 'option[2]').select_option
    find('#event_start_2i').find(:xpath, 'option[2]').select_option
    find('#event_start_1i').find(:xpath, 'option[2]').select_option
    find('#event_start_4i').find(:xpath, 'option[2]').select_option
    find('#event_start_5i').find(:xpath, 'option[2]').select_option

    find('#event_end_3i').find(:xpath, 'option[3]').select_option
    find('#event_end_2i').find(:xpath, 'option[3]').select_option
    find('#event_end_1i').find(:xpath, 'option[3]').select_option
    find('#event_end_4i').find(:xpath, 'option[3]').select_option
    find('#event_end_5i').find(:xpath, 'option[3]').select_option

    assert choose('event_location_on_campus'), "Couldn't set location field"
    assert fill_in('event_venue', with: 'Claverton Rooms'), "Couldn't set venue field"

    find('#event_audience').find(:xpath, 'option[3]').select_option
    find('#event_booking_method').find(:xpath, 'option[2]').select_option
    find('#event_charge').find(:xpath, 'option[2]').select_option

    click_button(I18n.t('shared.status_buttons.save_close'))

    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_event
    visit delete_path
    assert page.has_content?('For test deletion event'), 'Event to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_event_content_item).id
    event_id = events(:for_test_deletion_event).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Event.find(event_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion event'), 'Event not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Event.find(event_id) }
  end

  def test_status_does_not_change_on_validation_error
    event = events(:test_status_does_not_change_on_validation_error_event)
    visit edit_event_path(event.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert assert fill_in('event_booking_email', with: 'Blah blah blah'), "Couldn't fill in Booking Email"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
