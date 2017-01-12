require 'test_helper'

# Test Guides actions
class FeatureCaseStudyTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_new_case_study
    visit new_case_study_path

    assert page.has_content?('New case study'), 'Screen for creating a new case study not rendered properly'

    assert fill_in('case_study_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('case_study_content_item_attributes_i_need', with: 'to create a case study'), "Couldn't set i_need field"
    assert fill_in('case_study_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('case_study_content_item_attributes_title', with: 'Brand new case study'), "Couldn't set title field"
    assert fill_in('case_study_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"

    assert choose('case_study_subtype_research_case_study'), 'Could not choose research subtype'
    assert fill_in('case_study_body_content', with: 'Blah blah blah'), "Couldn't fill in body content"
    assert choose('case_study_call_to_action_type_url'), 'Could not choose url CTA type'
    assert fill_in('case_study_call_to_action_label', with: 'Activate'), "Couldn't set a CTA label"
    assert fill_in('case_study_call_to_action_content', with: 'http://www.joker.com'), "Couldn't set a CTA URL"

    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_case_study
    visit delete_path
    assert page.has_content?('For test deletion case study'), 'Case study to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_case_study_content_item).id
    case_study_id = case_studies(:for_test_deletion_case_study).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil CaseStudy.find(case_study_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion case study'), 'Case study not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { CaseStudy.find(case_study_id) }
  end

  def test_status_does_not_change_on_validation_error
    case_study = case_studies(:test_status_does_not_change_on_validation_error_case_study)
    visit edit_case_study_path(case_study.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert choose('case_study_call_to_action_type_url'), 'Could not choose url CTA type'
    assert assert fill_in('case_study_call_to_action_content', with: 'Blah blah blah'), "Couldn't fill in Call to Action URL"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
