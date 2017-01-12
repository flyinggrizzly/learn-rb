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

  def test_add_team_member_with_profile_no_js
    # Use rack driver for no JavaScript
    Capybara.current_driver = :rack_test
    team = team_profiles(:senior_managers)
    visit edit_team_profile_path(team.id)

    assert page.has_css?('select#team_profile_team_memberships_attributes_0_person_profile_id'), 'Missing select dropdown of Person Profiles'
    assert select(person_profiles(:pro_vice_chancellor_research).display_name_status,
                  from: 'team_profile[team_memberships_attributes][1][person_profile_id]')

    click_button(I18n.t('shared.status_buttons.save'))

    visit edit_team_profile_path(team.id)
    assert page.find('select#team_profile_team_memberships_attributes_1_person_profile_id option',
                     text: person_profiles(:pro_vice_chancellor_research).display_name_status).selected?
  end

  def test_add_team_member_with_profile
    visit new_team_profile_path

    # Check that there is an 'Add to team' button
    assert page.has_link?('Add to team'), "Page does not have an 'Add to team' button"
    assert page.find('a[data-button="add-profile"]').visible?, "Page does not have a visible 'Add to team' button"

    # Check that the default select box has been removed
    assert page.has_no_css?('#team_profile_person_profile_ids'),
           'Page has default select box. JS probably not loaded.'

    # Check that selecting a team member and clicking the 'Add to team' button adds a person
    option = "#{person_profiles(:pro_vice_chancellor_research).role_holder_name} - #{person_profiles(:pro_vice_chancellor_research).content_item.title}"
    assert select(option, from: 'dummy_person_profiles')
    click_link('Add to team')
    assert page.has_css?('.repeatable-field-medium', count: 1), 'Person not added to team'

    # Check that selecting another team member and clicking the 'Add to team' button adds a person
    option = "#{person_profiles(:vice_chancellor).role_holder_name} - #{person_profiles(:vice_chancellor).content_item.title}"
    assert select(option, from: 'dummy_person_profiles')
    click_link('Add to team')
    assert page.has_css?('.repeatable-field-medium', count: 2), 'A second person not added to team'
  end

  def test_delete_team_profile
    content_item_title = content_items(:for_test_deletion_team_profile_content_item).title

    visit delete_path
    assert page.has_content?(content_item_title), 'Team profile to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_team_profile_content_item).id
    team_profile_id = team_profiles(:for_test_deletion_team_profile).id
    person_profile_id = person_profiles(:for_test_survive_deletion_person_profile).id
    person_profile_content_item_id = content_items(:for_test_survive_deletion_person_profile_content_item).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil TeamProfile.find(team_profile_id)
    refute_nil PersonProfile.find(person_profile_id)
    refute_nil ContentItem.find(person_profile_content_item_id)

    # Prove the team profile has this person profile
    assert_equal 1, TeamProfile.find(team_profile_id).person_profiles.length
    assert_equal person_profile_id, TeamProfile.find(team_profile_id).person_profiles.first.id

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?(content_item_title), 'Team profile not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { TeamProfile.find(team_profile_id) }

    # team_profile should not have been deleted
    refute_nil PersonProfile.find(person_profile_id)
    refute_nil ContentItem.find(person_profile_content_item_id)
  end

  def test_delete_team_profile_subset
    content_item_title = content_items(:for_test_deletion_subset_team_profile_content_item).title

    visit delete_path
    assert page.has_content?(content_item_title), 'Team profile to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_subset_team_profile_content_item).id
    team_profile_id = team_profiles(:for_test_deletion_subset_team_profile).id
    subset_id = subsets(:for_test_deletion_subset).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil TeamProfile.find(team_profile_id)
    refute_nil Subset.find(subset_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?(content_item_title), 'Team profile to be deleted is missing'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { TeamProfile.find(team_profile_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Subset.find(subset_id) }
  end

  def test_remove_team_member_with_profile
    team = team_profiles(:senior_managers)
    visit edit_team_profile_path(team.id)

    # Check that there are 2 Remove buttons and 2 repeatable fields on the page
    assert page.has_css?('a.button-secondary.button-inline.negative', count: 2),
           "Page does not have 2 'Remove' buttons"
    assert page.has_css?('.repeatable-field-medium', count: 2),
           'Page does not have 2 repeatable fields'

    # Check that clicking the remove button removes the field
    all('a', text: 'Remove').first.click
    assert page.has_css?('.repeatable-field-medium', count: 1), "Field not removed from page using 'Remove' button"
  end

  def test_remove_then_add_team_member_with_profile
    team = team_profiles(:senior_managers)
    visit edit_team_profile_path(team.id)

    # Check that there are 2 Remove buttons and 2 repeatable fields on the page
    assert page.has_css?('a.button-secondary.button-inline.negative', count: 2),
           "Page does not have 2 'Remove' buttons"
    assert page.has_css?('.repeatable-field-medium', count: 2),
           'Page does not have 2 repeatable fields'

    # Check that select does not contain first added item
    person = first('.repeatable-field-medium').first('input').value
    assert page.has_no_select?('dummy_person_profiles', with_options: [person]), 'Added person should not be in the select options'

    # Check that clicking the remove button removes the field
    first('.repeatable-field-medium').first('a').click
    assert page.has_css?('.repeatable-field-medium', count: 1), "Field not removed from page using 'Remove' button"

    # Check it has been added to the select options
    assert page.has_select?('dummy_person_profiles', with_options: [person]), 'Removed person should be in the select options'

    # Add it back to check it has been added correctly
    assert select(person, from: 'dummy_person_profiles')
    click_link('Add to team')
    assert page.has_css?('.repeatable-field-medium', count: 2), 'Person not added back to team'

    # Save and check that the person is still a member
    click_button(I18n.t('shared.status_buttons.save'))
    assert page.has_css?('.repeatable-field-medium', count: 2), 'Person not added back to team after saving'
  end

  def test_add_then_remove_team_member_with_profile
    # Go to page
    team = team_profiles(:senior_managers)
    visit edit_team_profile_path(team.id)

    pvc = person_profiles(:pvc_learning_teaching)
    temp_member = "#{pvc.role_holder_name} - #{pvc.content_item.title}"

    # Non-member should only be listed in the dropdown of potential members
    assert page.has_no_field?('dummy_field', with: temp_member), 'Non-member should not be listed as a member'
    assert page.has_select?('dummy_person_profiles', with_options: [temp_member]), 'Non-member should be in dropdown'

    # Add non-member as a member
    assert select(temp_member, from: 'dummy_person_profiles'), "Couldn't add member"
    click_link('Add to team')
    assert page.has_css?('.repeatable-field-medium', count: 3), 'Should now be 3 members'
    last_member = all('.repeatable-field-medium').last.first('input').value
    assert_equal last_member, temp_member, 'New member should be listed last'

    # Remove the new member without saving and they should once again be only in the dropdown of potential members
    all('.repeatable-field-medium').last.first('a').click
    assert page.has_css?('.repeatable-field-medium', count: 2), "Field not removed from page using 'Remove' button"
    assert page.has_select?('dummy_person_profiles', with_options: [temp_member]), 'Future member should be in dropdown'
  end

  def test_publish_new_subsets_team_profile
    visit new_team_profile_path

    # Fill in required Content Item fields using field ID
    assert choose('team_profile_subtype_professional_service_team'), "Couldn't set subtype"
    assert fill_in('team_profile_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('team_profile_content_item_attributes_i_need', with: 'to fill in the form'), "Couldn't set i_need field"
    assert fill_in('team_profile_content_item_attributes_so_that', with: 'I can test it works'), "Couldn't set so_that field"
    assert fill_in('team_profile_content_item_attributes_title', with: 'Publish on creation test'), "Couldn't set title field"
    assert fill_in('team_profile_content_item_attributes_summary', with: 'This is a summary'), "Couldn't set summary field"

    # Fill in required Team profile fields using field ID
    assert fill_in('team_profile_duties', with: 'These are the duties'), "Couldn't set duties field"
    assert choose('team_profile_membership_type_subsets'), "Couldn't choose subsets membership_type"
    assert fill_in('team_profile_subsets_attributes_0_membership', with: '- Joe Bloggs'), "Couldn't set subset membership field"

    click_button(I18n.t('shared.status_buttons.publish'))
    assert page.has_content?('Publish on creation test'), 'Publishing a new Team profile did not work'
    assert page.has_content?('Published'), "Publishing a new Team profile didn't set status to 'Published'"
  end

  def test_status_does_not_change_on_validation_error
    team_profile = team_profiles(:test_status_does_not_change_on_validation_error_team_profile)
    visit edit_team_profile_path(team_profile.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert assert fill_in('team_profile_contact_email', with: 'Blah blah blah'), "Couldn't fill in Call to Action URL"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end

  def test_add_order_to_team_members_no_js
    # Use rack driver for no JavaScript
    Capybara.current_driver = :rack_test
    team_profile = team_profiles(:test_add_order_to_team_members)
    visit edit_team_profile_path(team_profile.id)

    vc_select_text = person_profiles(:vice_chancellor).display_name_status
    pvc_select_text = person_profiles(:pro_vice_chancellor_research).display_name_status

    # Check the initial order
    assert page.find('select#team_profile_team_memberships_attributes_0_person_profile_id option',
                     text: vc_select_text).selected?, 'VC should be first'
    assert page.find('select#team_profile_team_memberships_attributes_1_person_profile_id option',
                     text: pvc_select_text).selected?, 'PVC should be second'

    # Fill in order fields
    assert fill_in('team_profile_team_memberships_attributes_0_member_order', with: '42'), "Couldn't set 0 order field"
    assert fill_in('team_profile_team_memberships_attributes_1_member_order', with: '3'), "Couldn't set 1 order field"

    # Save the page and reopen it
    click_button(I18n.t('shared.status_buttons.save'))
    visit edit_team_profile_path(team_profile.id)

    # Check the order has updated
    assert page.find('select#team_profile_team_memberships_attributes_0_person_profile_id option',
                     text: pvc_select_text).selected?, 'PVC should be first'
    assert page.find('select#team_profile_team_memberships_attributes_1_person_profile_id option',
                     text: vc_select_text).selected?, 'VC should be second'
  end

  def test_reorder_team_members
    # This test edits the member_order fields manually instead of using the drag-and-drop functionality
    # We should replace this with a more accurate drag-and-drop simulation as soon as possible
    # Discovery story: https://www.pivotaltracker.com/n/projects/1262572/stories/133334621
    team_profile = team_profiles(:test_reorder_team_members_js)
    visit edit_team_profile_path(team_profile.id)

    vc = person_profiles(:vice_chancellor)
    pvc = person_profiles(:pro_vice_chancellor_research)

    # Check the initial order
    vc_text = "#{vc.role_holder_name} - #{vc.content_item.title}"
    pvc_text = "#{pvc.role_holder_name} - #{pvc.content_item.title}"

    # VC should be listed above PVC
    assert_equal vc_text, page.find('ul#team-members-list li:first-child').find('input[name="dummy_field"]').value,
                 'VC should be in first list item'
    assert_equal pvc_text, page.find('ul#team-members-list li:last-child').find('input[name="dummy_field"]').value,
                 'PVC should be in last list item'

    # Fill in order fields
    assert fill_in('team_profile_team_memberships_attributes_0_member_order', visible: false, with: '2'),
           "Couldn't set VC order field"
    assert fill_in('team_profile_team_memberships_attributes_1_member_order', visible: false, with: '1'),
           "Couldn't set PVC order field"

    # Save the page and reopen it
    click_button(I18n.t('shared.status_buttons.save'))
    visit edit_team_profile_path(team_profile.id)

    # Check the order has updated
    assert_equal pvc_text, page.find('ul#team-members-list li:first-child').find('input[name="dummy_field"]').value,
                 'PVC should be in first list item'
    assert_equal vc_text, page.find('ul#team-members-list li:last-child').find('input[name="dummy_field"]').value,
                 'VC should be in last list item'
  end
end
