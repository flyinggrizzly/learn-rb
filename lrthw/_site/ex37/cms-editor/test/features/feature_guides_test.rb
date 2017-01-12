require 'test_helper'

# Test Guides actions
class FeatureGuidesTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_should_create_guide
    visit new_guide_path

    assert page.has_content?('New guide'), 'Screen for creating a new guide not rendered properly'

    assert fill_in('guide_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('guide_content_item_attributes_i_need', with: 'to create a guide'), "Couldn't set i_need field"
    assert fill_in('guide_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('guide_content_item_attributes_title', with: 'Brand new guide'), "Couldn't set title field"
    assert fill_in('guide_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"
    assert choose('guide_subtype_basic_guide'), 'Could not choose basic guide subtype'
    assert choose('guide_call_to_action_type_url'), 'Could not choose url CTA type'
    assert fill_in('guide_call_to_action_label', with: 'Activate'), "Couldn't set a CTA label"
    assert fill_in('guide_call_to_action_content', with: 'http://www.batman.com'), "Couldn't set a CTA URL"
    assert fill_in('guide_sections_attributes_0_title', with: 'This is a section title'), "Couldn't set section title"
    assert fill_in('guide_sections_attributes_0_body_content', with: 'This is a section body'), "Couldn't set section body"

    assert click_button(I18n.t('shared.status_buttons.save_close'))
    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_guide
    visit delete_path
    assert page.has_content?('For test deletion guide'), 'Guide to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_guide_content_item).id
    guide_id = guides(:for_test_deletion_guide).id
    section_id = sections(:for_test_deletion_guide_section).id
    service_start_id = service_starts(:for_test_survive_deletion_service_start).id
    service_start_content_item_id = content_items(:for_test_survive_deletion_service_start_content_item).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Guide.find(guide_id)
    refute_nil Section.find(section_id)
    refute_nil ServiceStart.find(service_start_id)
    refute_nil ContentItem.find(service_start_content_item_id)

    # Prove the Guide has a Service Start and it is this one
    assert_equal 1, Guide.find(guide_id).service_starts.length
    assert_equal service_start_id, Guide.find(guide_id).service_starts.first.id

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion guide'), 'Guide not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Guide.find(guide_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Section.find(section_id) }

    # Service Start should not have been deleted
    refute_nil ServiceStart.find(service_start_id)
    refute_nil ContentItem.find(service_start_content_item_id)
  end

  def test_status_does_not_change_on_validation_error
    guide = guides(:test_status_does_not_change_on_validation_error_guide)
    visit edit_guide_path(guide.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert choose('guide_call_to_action_type_url'), 'Could not choose url CTA type'
    assert assert fill_in('guide_call_to_action_content', with: 'Blah blah blah'), "Couldn't fill in Call to Action URL"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
