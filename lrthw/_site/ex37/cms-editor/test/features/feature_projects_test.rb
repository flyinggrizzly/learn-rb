require 'test_helper'

# Test Person Profile actions
class FeatureProjectTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_add_new_project
    visit new_project_path

    # Fill in required Content Item fields using field ID
    assert choose('project_subtype_research_project'), "Couldn't choose research subtype"
    assert fill_in('project_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('project_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('project_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('project_content_item_attributes_title', with: 'test_add_new_project'), "Couldn't set title field"
    assert fill_in('project_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    assert choose('project_status_active'), "Couldn't choose active status"
    assert fill_in('project_project_overview', with: 'Project overview'), "Couldn't set project_overview field"

    click_button(I18n.t('shared.status_buttons.save_close'))

    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_add_new_project_with_partner_and_phase
    visit new_project_path

    # Fill in required Content Item fields using field ID
    assert choose('project_subtype_research_project'), "Couldn't choose research subtype"
    assert fill_in('project_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('project_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('project_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('project_content_item_attributes_title', with: 'test_add_new_project_with_partner_and_phase'), "Couldn't set title field"
    assert fill_in('project_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    assert choose('project_status_active'), "Couldn't choose active status"
    assert fill_in('project_project_overview', with: 'Project overview'), "Couldn't set project_overview field"

    # Add partner
    assert fill_in('project_partners_attributes_0_name', with: 'Partner name'), "Couldn't set partner name"

    # Add phase
    assert fill_in('project_phases_attributes_0_title', with: 'Phase title'), "Couldn't set phase title"
    assert fill_in('project_phases_attributes_0_summary', with: 'Phase summary'), "Couldn't set phase summary"

    click_button(I18n.t('shared.status_buttons.save_close'))

    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_add_new_project_with_missing_partner_name
    visit new_project_path

    # Fill in required Content Item fields using field ID
    assert choose('project_subtype_research_project'), "Couldn't choose research subtype"
    assert fill_in('project_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('project_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('project_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('project_content_item_attributes_title', with: 'test_add_new_project_with_missing_partner_name'), "Couldn't set title field"
    assert fill_in('project_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    assert choose('project_status_active'), "Couldn't choose active status"
    assert fill_in('project_project_overview', with: 'Project overview'), "Couldn't set project_overview field"

    # Add something in a non-required partner field
    assert fill_in('project_partners_attributes_0_logo_alt', with: 'alt text'), "Couldn't set partner logo alt text"

    click_button(I18n.t('shared.status_buttons.save_close'))

    assert page.has_content?(I18n.t('activerecord.errors.models.partner.attributes.name.blank')),
           "Validation wasn't triggered"
  end

  def test_delete_project
    visit delete_path
    assert page.has_content?('For test deletion project'), 'Project to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_project_content_item).id
    project_id = projects(:for_test_deletion_project).id
    phase_id = phases(:for_test_deletion_project_phase).id
    partner_id = partners(:for_test_deletion_project_partner).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Project.find(project_id)
    refute_nil Phase.find(phase_id)
    refute_nil Partner.find(partner_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion project'), 'Project not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Project.find(project_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Phase.find(phase_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Partner.find(partner_id) }
  end

  def test_status_does_not_change_on_validation_error
    project = projects(:test_status_does_not_change_on_validation_error_project)
    visit edit_project_path(project.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert assert fill_in('project_contact_email', with: 'Blah blah blah'), "Couldn't fill in Contact email"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
