require 'test_helper'

# Test Team Profile actions
class FeatureTeamProfileTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_new_save_action_message
    visit new_corporate_information_path

    # Fill in required Content Item fields using field ID
    assert fill_in('corporate_information_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('corporate_information_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('corporate_information_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('corporate_information_content_item_attributes_title', with: 'Test new save action message'), "Couldn't set title field"
    assert fill_in('corporate_information_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    # Fill in required corporate_information fields using field ID
    assert choose('corporate_information_subtype_code_of_practice'), "Couldn't choose code_of_practice subtype"
    assert fill_in('corporate_information_body_content', with: 'This is the body content'), "Couldn't set body_content field"
    assert choose('corporate_information_call_to_action_type_none'), 'Could not choose url CTA type'
    assert assert fill_in('corporate_information_call_to_action_reason', with: 'Blah blah blah'), "Couldn't fill in no CTA reason"

    click_button(I18n.t('shared.status_buttons.save'))
    assert page.has_content?(I18n.t('action_messages.new_save')),
           'Action message not working for save button on new content'
  end

  def test_in_review_publish_action_message
    team = team_profiles(:team_in_review)
    visit edit_team_profile_path(team.id)

    click_button(I18n.t('shared.status_buttons.publish'))
    assert page.has_content?(I18n.t('action_messages.in_review_publish')),
           'Action message not working for publish button on content in review'
  end

  def test_published_save_action_message
    team = team_profiles(:team_published)
    visit edit_team_profile_path(team.id)

    click_button(I18n.t('shared.status_buttons.published_save'))
    assert page.has_content?(I18n.t('action_messages.published_save')),
           'Action message not working for save button on published content'
  end

  def test_draft_save_and_close_action_message
    team = team_profiles(:team_draft_2)
    visit edit_team_profile_path(team.id)

    click_button(I18n.t('shared.status_buttons.save_close'))
    assert page.has_content?(I18n.t('action_messages.draft_save_close')),
           'Action message not working for save and close button on draft content'
  end
end
