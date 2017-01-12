require 'test_helper'

# Test setting associated orgs to content item
class FeatureSetAssociatedOrgTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_create_item_and_associate_with_orgs
    # Use corporate_information because it's short
    visit new_corporate_information_path

    # Fill in required Content Item fields using field ID
    assert fill_in('corporate_information_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('corporate_information_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('corporate_information_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('corporate_information_content_item_attributes_title', with: 'Test assoc orgs publish'), "Couldn't set title field"
    assert fill_in('corporate_information_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    # Fill in required corporate_information fields using field ID
    assert choose('corporate_information_subtype_code_of_practice'), "Couldn't choose code_of_practice subtype"
    assert fill_in('corporate_information_body_content', with: 'This is the body content'), "Couldn't set body_content field"
    assert choose('corporate_information_call_to_action_type_none'), 'Could not choose url CTA type'
    assert assert fill_in('corporate_information_call_to_action_reason', with: 'Blah blah blah'), "Couldn't fill in no CTA reason"

    assert select(organisations(:research_group).name), "Couldn't select Research Group"
    assert select(organisations(:science).name), "Couldn't select Fac Science"
    assert click_on(I18n.t('shared.status_buttons.save_close')), "Couldn't click on save"
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Page does not contain save button'

    # Visit root_path
    assert page.has_content?('Test assoc orgs publish'), 'New corporate_information not found on listing page'

    item = ContentItem.find_by_title('Test assoc orgs publish')
    assert item.associated_orgs.include? organisations(:research_group)
    assert item.associated_orgs.include? organisations(:science)
  end

  def test_associated_orgs_display_name_and_type
    team = team_profiles(:senior_managers)
    visit edit_team_profile_path(team.id)

    assert page.has_select?('team_profile_content_item_attributes_associated_org_ids', with_options: [organisations(:science).name_and_type])
  end
end
