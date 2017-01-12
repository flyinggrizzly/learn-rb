require 'test_helper'

# Test setting org to content item
class FeatureSetOrganisationTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls
  end

  def test_publisher_org_set_on_item_creation
    visit new_person_profile_path
    assert choose('Leadership'), 'Couldn\'t choose subtype'
    assert fill_in('person_profile_content_item_attributes_as_a', with: 'Developer'), 'Couldn\'t fill in as a'
    assert fill_in('person_profile_content_item_attributes_i_need', with: 'A new content item'), 'Couldn\'t set i_need field'
    assert fill_in('person_profile_content_item_attributes_so_that', with: 'I can check that the association with org works'), 'Couldn\'t set so_that field'
    assert fill_in('person_profile_content_item_attributes_title', with: 'Dark Knight'), 'Couldn\'t set title field'
    assert fill_in('person_profile_content_item_attributes_summary', with: 'This is a test piece of content'), 'Couldn\'t set summary field'
    assert fill_in('person_profile[role_holder_name]', with: 'Batman'), 'Couldn\t fill in role holder name'
    assert choose('person_profile_supervisor_availability_not_applicable')
    # Check that we only see one option which matches user's org
    refute has_select?('person_profile_content_item_attributes_organisation_id'), 'Should not be an org select box for new items'
    assert click_on(I18n.t('shared.status_buttons.save')), 'Couldn\'t click on save'

    visit root_path
    assert page.has_content?('Dark Knight'), 'New profile not found on listing page'

    profile = PersonProfile.find_by_role_holder_name('Batman')
    assert_equal organisations(:university_of_bath).name, profile.content_item.organisation.name
  end

  def test_select_owning_org_team_profile
    team = team_profiles(:senior_managers)
    visit edit_team_profile_path(team.id)

    assert select(organisations(:university_of_bath).name, from: 'team_profile_content_item_attributes_organisation_id')
  end

  def test_owning_orgs_display_name_and_type
    team = team_profiles(:senior_managers)
    visit edit_team_profile_path(team.id)

    assert page.has_select?('team_profile_content_item_attributes_organisation_id', with_options: [organisations(:university_of_bath).name_and_type])
  end

  def test_owning_orgs_ordered_for_admin
    team = team_profiles(:senior_managers)
    visit edit_team_profile_path(team.id)

    # Compare the org options and a sorted list of orgs
    org_select_options = find('#team_profile_content_item_attributes_organisation_id').all('option').collect(&:value)
    orgs = Organisation.order(name: :asc).map { |org| org.id.to_s }
    assert_equal orgs, org_select_options
  end

  def test_change_owning_org_team_profile
    other_org = organisations(:mar_comms)
    team = team_profiles(:senior_managers)
    visit edit_team_profile_path(team.id)

    assert select(other_org.name, from: 'team_profile_content_item_attributes_organisation_id')

    assert click_on(I18n.t('shared.status_buttons.save')), 'Couldn\t click on save'

    visit edit_team_profile_path(team.id)
    assert page.find('#team_profile_content_item_attributes_organisation_id option', text: organisations(:mar_comms).name).selected?, 'Department of Marketing and Communications is not selected as the owning org'
  end

  def test_select_owning_org_person_profile
    person = person_profiles(:pro_vice_chancellor_research)
    visit edit_person_profile_path(person.id)

    assert select(organisations(:university_of_bath).name, from: 'person_profile_content_item_attributes_organisation_id')
  end

  def test_change_owning_org_person_profile
    other_org = organisations(:mar_comms)
    person = person_profiles(:pro_vice_chancellor_research)
    visit edit_person_profile_path(person.id)

    assert select(other_org.name, from: 'person_profile_content_item_attributes_organisation_id')

    assert click_on(I18n.t('shared.status_buttons.published_save')), 'Couldn\t click on save'

    visit edit_person_profile_path(person.id)
    assert page.find('#person_profile_content_item_attributes_organisation_id option', text: organisations(:mar_comms).name).selected?, 'Department of Marketing and Communications is not selected as the owning org'
  end
end
