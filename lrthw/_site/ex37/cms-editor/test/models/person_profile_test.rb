require 'test_helper'

class PersonProfileTest < ActiveSupport::TestCase
  def setup
    @person = person_profiles(:maximum_length_values_valid)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of PersonProfile, @person, 'Should be a PersonProfile'
    assert PersonProfile.method_defined?(:published_version), 'PersonProfile should include CanHavePublishingMetadataHooks'
    assert defined?(@person.last_published_version), 'PersonProfile should have a last_published_version field'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @person.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @person.content_item.published!
    @person.save!
    assert_equal @person.content_item.url_path,
                 JSON.parse(@person.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_valid
    assert person_profiles(:vice_chancellor_valid).valid?, 'Vice Chancellor should have been valid'
    assert @person.valid?, 'Maximum lengths should have been valid - has someone reduced a length?'
  end

  def test_invalid_role_holder
    profile = person_profiles(:role_holder_name_invalid)
    refute profile.valid?, 'Role holder name should have failed validation'
  end

  def test_display_name_status
    assert_equal "#{person_profiles(:pvc_research).role_holder_name} - #{content_items(:pvc_research_content_item).title} - #{I18n.t('publish_status.published')}",
                 person_profiles(:pvc_research).display_name_status
  end

  def test_set_supervision
    pro_vc = person_profiles(:pro_vice_chancellor_research)
    assert_equal 'proposals', pro_vc.supervisor_availability
    pro_vc.supervisor_availability = 3
    assert pro_vc.valid?
    assert_equal 'not_applicable', pro_vc.supervisor_availability
  end

  def test_supervisor_not_applicable_in_output
    refute person_profiles(:staff_member1).output_attributes.include?('supervisor_availability')
  end

  def test_supervisor_accepting_proposals_in_output
    output = person_profiles(:pvc_research).output_attributes
    assert output.include?('supervisor_availability')
    assert_equal 'open to proposals for student research projects', output['supervisor_availability']
  end

  def test_leadership_profile_url
    profile = person_profiles(:leadership_subtype_url_path)
    assert_nil profile.content_item.url_path, 'url_path should be nil for this PersonProfile'
    profile.save
    assert_equal '/profiles/leadership-subtype-url-path-content-item-name', profile.content_item.url_path,
                 'PersonProfile url_path should match the title plus role_holder_name'
  end

  def test_staff_profile_url
    profile = person_profiles(:staff_subtype_url_path)
    assert_nil profile.content_item.url_path, 'url_path should be nil for this PersonProfile'
    profile.save
    assert_equal '/profiles/staff-subtype-url-path-content-item-name', profile.content_item.url_path,
                 'PersonProfile url_path should match the title plus role_holder_name'
  end

  def test_academic_profile_url
    profile = person_profiles(:academic_subtype_url_path)
    assert_nil profile.content_item.url_path, 'url_path should be nil for this PersonProfile'
    profile.save
    assert_equal '/profiles/academic-subtype-url-path-content-item-name', profile.content_item.url_path,
                 'PersonProfile url_path should match the title plus role_holder_name'
  end
end
