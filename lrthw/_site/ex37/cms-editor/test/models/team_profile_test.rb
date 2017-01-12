require 'test_helper'

class TeamProfileTest < ActiveSupport::TestCase
  def setup
    # Grab an item from fixtures
    @marketing = team_profiles(:marketing)
    @team_subsets = team_profiles(:team_with_subsets)
    @team_profiles = team_profiles(:team_with_profiles)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of TeamProfile, team_profiles(:maximum_length_values_valid), 'Should be a TeamProfile'
    assert TeamProfile.method_defined?(:published_version), 'TeamProfile should include CanHavePublishingMetadataHooks'
    assert defined?(team_profiles(:maximum_length_values_valid).last_published_version), 'TeamProfile should have a last_published_version field'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    team_profile = team_profiles(:saved_url_path_for_funnelback)
    team_profile.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    team_profile.content_item.published!
    team_profile.save!
    assert_equal team_profile.content_item.url_path,
                 JSON.parse(team_profile.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_save_last_published_version_number
    profile = team_profiles(:save_last_published_version_number_team)
    assert profile.valid?, 'TeamProfile should be valid'
    assert profile.last_published_version.blank?, 'Should not yet have been published'

    # Check that an update doesn't set the publish version
    profile.duties = 'Duty update 1'
    profile.content_item.draft!
    profile.save!
    profile = TeamProfile.find(profile.id)
    assert_nil profile.last_published_version, 'Should not yet have been published'

    # Publish and check it sets the publish version
    profile.duties = 'Duty update 2'
    profile.content_item.published!
    profile.save!
    profile = TeamProfile.find(profile.id)
    refute_nil profile.last_published_version, 'Should have a published version'
    assert_equal 2, profile.last_published_version
  end

  def test_last_published_version
    profile = team_profiles(:last_published_team)
    assert profile.valid?, 'TeamProfile should be valid'
    assert profile.last_published_version.blank?, 'Should not yet have been published'

    # An unpublished item should return nil
    assert_nil profile.published_version

    # Publish it then we should get the same item back
    assert profile.content_item.status = 3, 'Failed to publish'
    profile.save!
    profile = TeamProfile.find(profile.id)
    refute_nil profile.published_version

    # Use json for comparison to avoid having to override == content item objects
    first_published_json = profile.published_version.to_json
    refute_nil first_published_json
    assert_equal profile.to_json, first_published_json

    # Make an unpublished change and we should get the published one back
    profile.duties = 'New duties'
    profile.content_item.status = 0
    profile.save!
    profile = TeamProfile.find(profile.id)

    refute_equal profile.to_json, profile.published_version.to_json
    assert_equal first_published_json, profile.published_version.to_json
  end

  def test_valid
    assert team_profiles(:maximum_length_values_valid).valid?, 'Maximum lengths should have been valid - has someone reduced a length?'
  end

  def test_invalid_duties
    profile = team_profiles(:duties_invalid)
    refute profile.valid?, 'Duties should have failed validation'
  end

  def test_add_member_with_profile
    assert @marketing.person_profiles.blank?

    member = person_profiles(:staff_member1)
    @marketing.person_profiles << member
    @marketing.save

    refute @marketing.person_profiles.blank?
  end

  def test_add_subset
    assert @team_subsets.person_profiles.blank?, "team_with_subsets shouldn't have any person_profiles"
    assert_equal @team_subsets.subsets.count, 3, "team_with_subsets doesn't have 3 subsets"

    subset = subsets(:marketing_subset)
    @team_subsets.subsets << subset
    @team_subsets.save

    assert_equal @team_subsets.subsets.count, 4, "New subset wasn't added"
  end

  def test_no_subsets_for_profiles_team_validation
    assert @team_profiles.valid?, 'Profiles team should be valid'
    assert @team_profiles.subsets.blank?, 'Profiles team should have no subsets'

    subset = subsets(:marketing_subset)
    @team_profiles.subsets << subset
    @team_profiles.save

    refute @team_profiles.valid?, 'Profiles team with subset should not have be valid'
  end

  def test_output_attributes_for_team_members
    refute team_profiles(:committee).person_profiles.blank?, 'No team members for Committee team profile'
    output = team_profiles(:committee).output_attributes
    refute output[:team_members].blank?, 'Team Members should not be blank for Team Profile'
    assert output[:team_members].to_s.include?('Vice Chancellor'), 'Vice Chancellor not among team members for Committee'
    assert output[:team_members].to_s.include?('Valued staff'), 'Valued staff not among team members for Committee'
  end

  def test_output_attributes_for_contact_name
    output = team_profiles(:committee).output_attributes
    refute output['contact_name'].blank?, 'Contact name for committee team profile not in output'
    assert_equal output['contact_name'], 'The chair'
  end

  def test_output_for_subsets
    refute @team_subsets.subsets.blank?, 'Team profile should have subsets'
    output = @team_subsets.output_attributes
    refute output[:subsets].blank?, 'Sections should not be blank for Team profile in output'
  end

  def test_output_for_preview
    # Fetch the draft
    team_profile = team_profiles(:test_team_profile_output_for_preview)
    refute_nil team_profile

    # Publish it to ensure we trigger Papertrail
    team_profile.content_item.status = ContentItem.statuses[:published]
    team_profile.save

    # Check there's a published_version
    refute team_profile.published_version.blank?
    assert_equal team_profile.published_version, team_profile
    assert_equal team_profile.output_attributes['duties'], team_profile.duties

    # Change values and set For Review
    refute_nil team_profile.content_item
    team_profile.content_item.summary = 'Summary after preview'
    team_profile.duties = 'This is what I say AFTER Review'
    team_profile.content_item.status = ContentItem.statuses[:review]
    team_profile.save

    # Check that output_attributes isn't the same as last published version attributes
    refute team_profile.output_attributes.blank?
    assert_equal team_profile.duties, team_profile.output_attributes['duties']
    refute_equal team_profile.versions[team_profile.last_published_version].reify(has_one: true, has_many: true).duties,
                 team_profile.output_attributes['duties']
  end

  def test_order_of_team_members_for_output
    # Get the output
    output = team_profiles(:test_order_of_team_members_for_output).output_attributes

    # Team members are passed to the output in the order specified by the user
    top_member_name = person_profiles(:vice_chancellor_published).role_holder_name
    assert_equal top_member_name, output[:team_members].first[:role_holder_name], "Member with lowest order isn't first"

    # If two team members have the same order, they are sorted alphabetically by name
    team_member_named_a = team_memberships(:test_order_of_team_members_for_output_team_member_named_a)
    team_member_named_b = team_memberships(:test_order_of_team_members_for_output_team_member_named_b)
    assert team_member_named_a[:member_order] == team_member_named_b[:member_order], "Members don't have the same order"

    # Get the role holder names of the team members
    name_a = team_member_named_a.person_profile.role_holder_name
    name_b = team_member_named_b.person_profile.role_holder_name

    # Compare the indexes of team members who have the same order number
    team_member_named_a_index = output[:team_members].index { |m| m[:role_holder_name] == name_a }
    team_member_named_b_index = output[:team_members].index { |m| m[:role_holder_name] == name_b }
    assert team_member_named_a_index < team_member_named_b_index, "Members with same order aren't sorted alphabetically"

    # If a team member has no order, they are after the ones that do have orders
    assert_equal 'Valued staff one', output[:team_members].last[:role_holder_name], "Member without an order isn't last"
  end
end
