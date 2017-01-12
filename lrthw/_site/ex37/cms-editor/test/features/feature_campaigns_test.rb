require 'test_helper'

# Test Person Profile actions
class FeatureCampaignTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_new_campaign
    visit new_campaign_path

    # Fill in required Content Item fields using field ID
    assert choose('campaign_subtype_campus_campaign'), "Couldn't choose campus subtype"
    assert fill_in('campaign_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('campaign_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('campaign_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('campaign_content_item_attributes_title', with: 'test_add_new_campaign'), "Couldn't set title field"
    assert fill_in('campaign_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    assert choose('campaign_status_open'), "Couldn't choose open status"

    find('#campaign_start_3i').find(:xpath, 'option[2]').select_option
    find('#campaign_start_2i').find(:xpath, 'option[2]').select_option
    find('#campaign_start_1i').find(:xpath, 'option[2]').select_option

    find('#campaign_end_3i').find(:xpath, 'option[3]').select_option
    find('#campaign_end_2i').find(:xpath, 'option[3]').select_option
    find('#campaign_end_1i').find(:xpath, 'option[3]').select_option

    assert fill_in('campaign_supporting_information', with: 'Campaign supporting information'),
           "Couldn't set supporting_information field"

    assert fill_in('campaign_benefits_attributes_0_description', with: 'Benefit description'),
           "Couldn't set campaign_benefits_attributes_0_description field"
    assert choose('campaign_benefits_attributes_0_call_to_action_type_url'), 'Could not choose url CTA type'
    assert fill_in('campaign_benefits_attributes_0_call_to_action_label', with: 'Benefit CTA'),
           "Couldn't set campaign_benefits_attributes_0_call_to_action_label field"
    assert fill_in('campaign_benefits_attributes_0_call_to_action_content', with: 'http://www.bath.ac.uk'),
           "Couldn't set campaign_benefits_attributes_0_call_to_action_content field"

    click_button(I18n.t('shared.status_buttons.save_close'))

    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_add_new_campaign_with_partner_and_benefit
    visit new_campaign_path

    # Fill in required Content Item fields using field ID
    assert choose('campaign_subtype_campus_campaign'), "Couldn't choose campus subtype"
    assert fill_in('campaign_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('campaign_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('campaign_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('campaign_content_item_attributes_title', with: 'test_add_new_campaign_with_partner_and_benefit'), "Couldn't set title field"
    assert fill_in('campaign_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    assert choose('campaign_status_open'), "Couldn't choose open status"

    find('#campaign_start_3i').find(:xpath, 'option[2]').select_option
    find('#campaign_start_2i').find(:xpath, 'option[2]').select_option
    find('#campaign_start_1i').find(:xpath, 'option[2]').select_option

    find('#campaign_end_3i').find(:xpath, 'option[3]').select_option
    find('#campaign_end_2i').find(:xpath, 'option[3]').select_option
    find('#campaign_end_1i').find(:xpath, 'option[3]').select_option

    assert fill_in('campaign_supporting_information', with: 'Campaign supporting information'),
           "Couldn't set campaign_supporting_information field"

    # Add partner
    assert fill_in('campaign_partners_attributes_0_name', with: 'Partner name'), "Couldn't set partner name"

    # Add benefit
    assert fill_in('campaign_benefits_attributes_0_description', with: 'Benefit title'),
           "Couldn't set benefit description"
    assert choose('campaign_benefits_attributes_0_call_to_action_type_url'), 'Could not choose url CTA type'
    assert fill_in('campaign_benefits_attributes_0_call_to_action_label', with: 'Benefit link text'),
           "Couldn't set benefit call to action link text"
    assert fill_in('campaign_benefits_attributes_0_call_to_action_content', with: 'http://www.bath.ac.uk'),
           "Couldn't set benefit call to action content"

    click_button(I18n.t('shared.status_buttons.save_close'))

    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_campaign
    visit delete_path
    assert page.has_content?('For test deletion campaign'), 'Campaign to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_campaign_content_item).id
    campaign_id = campaigns(:for_test_deletion_campaign).id
    benefit_id = benefits(:for_test_deletion_campaign_benefit).id
    partner_id = partners(:for_test_deletion_campaign_partner).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Campaign.find(campaign_id)
    refute_nil Benefit.find(benefit_id)
    refute_nil Partner.find(partner_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion campaign'), 'Campaign not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Campaign.find(campaign_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Benefit.find(benefit_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Partner.find(partner_id) }
  end

  def test_status_does_not_change_on_validation_error
    campaign = campaigns(:test_status_does_not_change_on_validation_error_campaign)
    visit edit_campaign_path(campaign.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert assert fill_in('campaign_contact_email', with: 'Blah blah blah'), "Couldn't fill in Contact email"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
