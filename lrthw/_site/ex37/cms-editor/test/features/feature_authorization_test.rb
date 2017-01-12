require 'test_helper'

# Test authorization
class AuthorizationTest < Capybara::Rails::TestCase
  def setup
    # Use a known admin here
    CASClient::Frameworks::Rails::Filter.fake('if243')
    # Use webkit and block unknown urls
    Capybara.current_driver = :webkit
    Capybara.page.driver.block_unknown_urls
  end

  def test_author_publish
    # Drop permissions to author
    visit root_path + '?set-role=author'
    # Use corporate_information because it's short
    visit new_corporate_information_path

    # Fill in required Content Item fields using field ID
    assert fill_in('corporate_information_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('corporate_information_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('corporate_information_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('corporate_information_content_item_attributes_title', with: 'Test author publish'), "Couldn't set title field"
    assert fill_in('corporate_information_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    # Fill in required corporate_information fields using field ID
    assert choose('corporate_information_subtype_code_of_practice'), "Couldn't choose code_of_practice subtype"
    assert fill_in('corporate_information_body_content', with: 'This is the body content'), "Couldn't set body_content field"
    assert choose('corporate_information_call_to_action_type_none'), 'Could not choose url CTA type'
    assert assert fill_in('corporate_information_call_to_action_reason', with: 'Blah blah blah'), "Couldn't fill in no CTA reason"

    click_button(I18n.t('shared.status_buttons.publish'))

    # Should end up on the content item listing page
    assert page.has_content?('Test author publish'), 'Publishing a new corporate_information as author did not work'
    assert page.has_content?('Published'), "Publishing a new corporate_information didn't set status to 'Published'"
  end

  # Ensure that there is no publish button for a contributor
  def test_contributor_no_publish_button
    # Drop permissions to contributor
    visit root_path + '?set-role=contributor'
    visit new_corporate_information_path

    # check there is a save button
    assert page.has_button?(I18n.t('shared.status_buttons.save')), 'There should be a save button'

    # check there is not a publish button
    assert page.has_no_button?(I18n.t('shared.status_buttons.publish')), 'There should not be a publish button'
  end

  # check that a contributor can't publish even if the form is modified
  def test_contributor_no_publish_controller
    # Drop permissions to contributor
    visit root_path + '?set-role=contributor'
    # Use corporate_information because it's short
    visit new_corporate_information_path

    # Fill in required Content Item fields using field ID
    assert fill_in('corporate_information_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('corporate_information_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('corporate_information_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('corporate_information_content_item_attributes_title', with: 'Test contributor no publish controller'), "Couldn't set title field"
    assert fill_in('corporate_information_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    # Fill in required corporate_information fields using field ID
    assert choose('corporate_information_subtype_code_of_practice'), "Couldn't choose code_of_practice subtype"
    assert fill_in('corporate_information_body_content', with: 'This is the body content'), "Couldn't set body_content field"
    assert choose('corporate_information_call_to_action_type_none'), 'Could not choose url CTA type'
    assert assert fill_in('corporate_information_call_to_action_reason', with: 'Blah blah blah'), "Couldn't fill in no CTA reason"

    add_publish_button(page)
    click_button(I18n.t('shared.status_buttons.publish'))

    # Should end up on the permission denied page
    assert_equal url_for(controller: :error, action: :no_permissions, only_path: true), page.current_path
  end

  private

  def add_revert_button(page)
    add_button(page, I18n.t('shared.status_buttons.revert'))
  end

  def add_publish_button(page)
    add_button(page, I18n.t('shared.status_buttons.publish'))
  end

  def add_button(page, value)
    button = '<input type="submit" class="button-save" value="' + value + '" name="commit">'
    # Add a new button after the last input, whatever that happens to be
    page.execute_script("$('input:last').after('" + button + "')")
  end
end
