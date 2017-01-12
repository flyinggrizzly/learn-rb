require 'test_helper'

# Test actions on login create a user and associate to Organisation
class FeatureGroupTest < Capybara::Rails::TestCase
  def setup
    # Have to test with a real person as cms-test-user doesn't come up in Person Finder
    CASClient::Frameworks::Rails::Filter.fake('if243')
  end

  def test_select_owning_org_group
    group = organisations(:feature_test_group)
    visit edit_group_path(group.id)
    assert select(organisations(:university_of_bath).name, from: 'group_parent_organisation_id')
  end

  def test_display_group_name_and_type
    group = organisations(:feature_test_group)
    visit edit_group_path(group.id)
    assert page.has_select?('group_parent_organisation_id', with_options: [organisations(:university_of_bath).name_and_type])
    assert page.has_select?('group_associated_group_org_ids', with_options: [organisations(:research_group).name_and_type])
  end

  def test_change_owning_org_group
    other_org = organisations(:mar_comms)
    group = organisations(:feature_test_group)
    visit edit_group_path(group.id)

    assert select(other_org.name, from: 'group_parent_organisation_id')

    # submit form
    find('input[name="commit"]').click

    visit edit_group_path(group.id)
    assert page.find('#group_parent_organisation_id option', text: organisations(:mar_comms).name).selected?, 'Department of Marketing and Communications is not selected as the owning org'
  end

  def test_change_assoc_org_group
    group = organisations(:feature_test_group)
    visit edit_group_path(group.id)

    org = organisations(:science)
    assert select(org.name, from: 'group_associated_group_org_ids')

    # submit form
    find('input[name="commit"]').click

    visit edit_group_path(group.id)
    assert page.find('#group_associated_group_org_ids option', text: organisations(:science).name).selected?, 'Science is not selected as the associated org'
  end
end
