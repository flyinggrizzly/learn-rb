require 'test_helper'

# Test Announcement actions
class FeatureExternalItemTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_new_external_item
    visit new_external_item_path

    assert page.has_content?('New external item'), 'Screen for creating a new external item not rendered properly'

    assert fill_in('external_item_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('external_item_content_item_attributes_i_need', with: 'to create a external_item'),
           "Couldn't set i_need field"
    assert fill_in('external_item_content_item_attributes_so_that', with: 'I can test whether the form is ok'),
           "Couldn't set so_that field"
    assert fill_in('external_item_content_item_attributes_title', with: 'Brand new external_item'),
           "Couldn't set title field"
    assert fill_in('external_item_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"

    assert choose('external_item_subtype_university'), 'Could not choose university subtype'
    assert fill_in('external_item_external_url', with: 'http://blogs.bath.ac.uk/iprblog/'),
           "Couldn't fill in external_url"

    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_external_item
    visit delete_path
    assert page.has_content?('test_deletion_external_item test'), 'ExternalItem to be deleted is missing'

    content_item_id = content_items(:test_deletion_external_item_content_item).id
    external_item_id = external_items(:test_deletion_external_item).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil ExternalItem.find(external_item_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('test_deletion_external_item test'), 'ExternalItem not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { ExternalItem.find(external_item_id) }
  end

  def test_status_does_not_change_on_validation_error
    external_item = external_items(:test_status_does_not_change_on_validation_error_external_item)
    visit edit_external_item_path(external_item.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert assert fill_in('external_item_external_url', with: 'Blah blah blah'), "Couldn't fill in External URL"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
