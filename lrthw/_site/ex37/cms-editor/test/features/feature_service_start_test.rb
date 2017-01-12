require 'test_helper'

# Test Service Start actions
class FeatureServiceStartTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_new_service_start
    visit new_service_start_path

    assert page.has_content?('New service start'), 'Screen for creating a new service start not rendered properly'

    assert fill_in('service_start_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('service_start_content_item_attributes_i_need', with: 'to create a service start'), "Couldn't set i_need field"
    assert fill_in('service_start_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('service_start_content_item_attributes_title', with: 'Brand new service start'), "Couldn't set title field"
    assert fill_in('service_start_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"

    assert fill_in('service_start_usage_instructions', with: 'These are some usage_instructions'), "Couldn't fill in usage_instructions"
    assert select(guides(:tea_making_guide).display_title), "Couldn't select 'How to make tea'"
    assert select(guides(:text_limit_guide).display_title), "Couldn't select 'Maximum text lengths guide'"
    assert choose('service_start_call_to_action_type_url'), 'Could not choose url CTA type'
    assert fill_in('service_start_call_to_action_label', with: 'Start'), "Couldn't set a CTA label"
    assert fill_in('service_start_call_to_action_content', with: 'http://www.google.com'), "Couldn't set a CTA URL"

    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_service_start
    visit delete_path
    assert page.has_content?('For test deletion service start'), 'Service start to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_service_start_content_item).id
    service_start_id = service_starts(:for_test_deletion_service_start).id
    guide_id = guides(:for_test_survive_deletion_guide).id
    section_id = sections(:for_test_survive_deletion_guide_section).id
    guide_content_item_id = content_items(:for_test_survive_deletion_guide_content_item).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil ServiceStart.find(service_start_id)
    refute_nil Guide.find(guide_id)
    refute_nil Section.find(section_id)
    refute_nil ContentItem.find(guide_content_item_id)

    # Prove the Service Start has a Guide and it is this one
    assert_equal 1, ServiceStart.find(service_start_id).guides.length
    assert_equal guide_id, ServiceStart.find(service_start_id).guides.first.id

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion service start'), 'Service start not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { ServiceStart.find(service_start_id) }

    # Guide should not have been deleted
    refute_nil Guide.find(guide_id)
    refute_nil Section.find(section_id)
    refute_nil ContentItem.find(guide_content_item_id)
  end

  def test_status_does_not_change_on_validation_error
    service_start = service_starts(:test_status_does_not_change_on_validation_error_service_start)
    visit edit_service_start_path(service_start.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert choose('service_start_call_to_action_type_url'), 'Could not choose url CTA type'
    assert assert fill_in('service_start_call_to_action_content', with: 'Blah blah blah'), "Couldn't fill in Call to Action URL"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
