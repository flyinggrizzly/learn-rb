require 'test_helper'

# Test Person Profile actions
class FeaturePersonProfileTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_select_supervision_option
    visit new_person_profile_path

    assert page.has_content?(I18n.t('person_profiles.form.supervisor_availability'))
    assert page.has_content?(I18n.t('person_profiles.form.supervisor_availability_not_applicable'))

    # fill in required Content Item fields using field ID
    assert choose('person_profile_subtype_staff_profile'), "Couldn't choose staff subtype"
    assert fill_in('person_profile_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('person_profile_content_item_attributes_i_need', with: 'to set supervisor_availability'), "Couldn't set i_need field"
    assert fill_in('person_profile_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('person_profile_content_item_attributes_title', with: 'Supervision not applicable profile'), "Couldn't set title field"
    assert fill_in('person_profile_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"

    # fill in required Person Profile fields using field ID
    assert fill_in('person_profile_role_holder_name', with: 'Testing robot without supervision')
    assert choose('person_profile_supervisor_availability_not_applicable')
    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    person = PersonProfile.find_by_role_holder_name('Testing robot without supervision')
    visit edit_person_profile_path(person.id)
    assert find_field('person_profile_supervisor_availability_not_applicable').checked?
  end

  def test_add_new_person_with_invalid_content_item_fields
    summary_over_255_chars = 'A' * 300

    visit new_person_profile_path

    # fill in required Content Item fields using field ID
    assert choose('person_profile_subtype_staff_profile'), "Couldn't choose staff subtype"
    assert fill_in('person_profile_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('person_profile_content_item_attributes_i_need', with: 'to enter too much text'), "Couldn't set i_need field"
    assert fill_in('person_profile_content_item_attributes_so_that', with: 'I can test data inconsistency'), "Couldn't set so_that field"
    assert fill_in('person_profile_content_item_attributes_title', with: 'test_add_new_person_with_invalid_content_item_fields'), "Couldn't set title field"
    assert fill_in('person_profile_content_item_attributes_summary', with: summary_over_255_chars), "Couldn't set summary field"

    # fill in required Person Profile fields using field ID
    assert fill_in('person_profile_role_holder_name', with: 'Testing robot')
    assert choose('person_profile_supervisor_availability_not_applicable')

    click_button(I18n.t('shared.status_buttons.save'))

    assert_equal person_profiles_path, page.current_path, 'Validation error did not return us to the create page'
    assert page.has_content?(I18n.t('shared.validation_errors.error_prefix')), 'Validation error not displayed'
  end

  def test_delete_person_profile
    visit delete_path
    assert page.has_content?('For test deletion person profile'), 'Person profile to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_person_profile_content_item).id
    person_profile_id = person_profiles(:for_test_deletion_person_profile).id
    url_id = urls(:for_test_deletion_person_profile_url).id
    team_profile_id = team_profiles(:for_test_survive_deletion_team_profile).id
    team_profile_content_item_id = content_items(:for_test_survive_deletion_team_profile_content_item).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil PersonProfile.find(person_profile_id)
    refute_nil Url.find(url_id)
    refute_nil TeamProfile.find(team_profile_id)
    refute_nil ContentItem.find(team_profile_content_item_id)

    # Prove the person profile has a team_profile and it is this one
    assert_equal 1, PersonProfile.find(person_profile_id).team_profiles.length
    assert_equal team_profile_id, PersonProfile.find(person_profile_id).team_profiles.first.id

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion person profile'), 'Person profile not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { PersonProfile.find(person_profile_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Url.find(url_id) }

    # team_profile should not have been deleted
    refute_nil TeamProfile.find(team_profile_id)
    refute_nil ContentItem.find(team_profile_content_item_id)
  end

  def test_status_does_not_change_on_validation_error
    person_profile = person_profiles(:test_status_does_not_change_on_validation_error_person_profile)
    visit edit_person_profile_path(person_profile.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert assert fill_in('person_profile_contact_email', with: 'Blah blah blah'), "Couldn't fill in Contact email"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end

  def test_publish_associated_team_profile
    # First publish the team to populate the published_item_json field and PaperTrail version tables
    team = team_profiles(:test_publish_associated_team_profile_team_profile)
    visit edit_team_profile_path(team.id)
    assert click_button(I18n.t('shared.status_buttons.publish'))
    assert_equal root_path, page.current_path, 'Page did not save correctly'

    # Test publishing person triggers team publish
    person_profile = person_profiles(:test_publish_associated_team_profile_person_profile)
    visit edit_person_profile_path(person_profile.id)
    # Change the role holder name
    assert fill_in('person_profile_role_holder_name', with: 'New role holder name'),
           "Couldn't fill in role holder name"
    assert click_button(I18n.t('shared.status_buttons.publish'))
    assert_equal root_path, page.current_path, 'Page did not save correctly'

    # Check the role holder name has changed on the Person Profile
    person = PersonProfile.find_by_role_holder_name('New role holder name')
    assert person.content_item.published_item_json.include?('New role holder name'),
           'Person Profile role holder name not updated'

    # Check the role holder name has changed on the Team Profile
    assert team.content_item.published_item_json.include?('New role holder name'),
           'Team Profile person role holder name not updated'

    # Test that draft changes don't get published
    # Change the duties on the Team and save as draft
    visit edit_team_profile_path(team.id)
    assert fill_in('team_profile_duties', with: 'Changed duties for draft'), "Couldn't fill in duties"
    assert click_button(I18n.t('shared.status_buttons.save_close'))
    assert_equal root_path, page.current_path, 'Page did not save correctly'

    # Change the role holder name again
    visit edit_person_profile_path(person_profile.id)
    assert fill_in('person_profile_role_holder_name', with: 'Another role for draft test'),
           "Couldn't fill in role holder name"
    assert click_button(I18n.t('shared.status_buttons.publish'))
    assert_equal root_path, page.current_path, 'Page did not save correctly'

    # Check that the draft changes are not in the published_item_json
    team_reloaded = TeamProfile.find(team.id)
    refute team_reloaded.content_item.published_item_json.include?('Changed duties for draft'),
           'Team Profile draft changes published'
    # Check that the person changes are in the published_item_json
    assert team_reloaded.content_item.published_item_json.include?('Another role for draft test'),
           'Team Profile person role holder name not updated'
  end
end
