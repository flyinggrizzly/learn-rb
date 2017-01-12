require 'test_helper'
require 'json'

class ProjectTest < ActiveSupport::TestCase
  def test_featured_image_concern_included
    assert Project.include?(CanHaveFeaturedImage), 'CanHaveFeaturedImage concern should have been included'
  end

  def test_valid
    assert projects(:maximum_length_values_project).valid?, 'Off campus event should have been valid'
  end

  def test_start_after_end_invalid
    refute projects(:start_after_end_project).valid?, 'End date should be required to be after start date'
  end

  def test_image_url_invalid
    refute projects(:invalid_image_url_project).valid?, 'Image url should be required to be a valid url'
  end

  def test_missing_image_alt_invalid
    refute projects(:missing_image_alt_project).valid?, 'Image alt should be required if image url present'
  end

  def test_missing_image_caption_invalid
    refute projects(:missing_image_caption_project).valid?, 'Image caption should be required if image url present'
  end

  def test_missing_embed_code_invalid
    refute projects(:missing_embed_code_project).valid?, 'Embed code should be required if object title present'
  end

  def test_missing_object_title_invalid
    refute projects(:missing_object_title_project).valid?, 'Object title should be required if embed code present'
  end

  def test_with_pound_sign_invalid
    refute projects(:with_pound_sign_project).valid?, "Budget should be invalid if there's a pound sign in the field"
    refute phases(:with_pound_sign_phase).valid?, "Phase budget should be invalid if there's a pound sign in the field"
  end

  def test_output_attributes_for_projects
    assert projects(:test_output_attributes_for_projects).valid?, 'Project should be valid'
    output = projects(:test_output_attributes_for_projects).output_attributes

    # Check project status is being changed properly
    refute output['status'].blank?, 'Project status should not have been blank'
    assert_equal I18n.t('projects.status_output_active'), output['status'], 'Project status should match output in language file'
  end

  def test_output_attributes_for_partners
    refute projects(:maximum_length_values_project).partners.blank?, 'Project should have a partner'
    output = projects(:maximum_length_values_project).output_attributes
    refute output[:partners].blank?, 'Partner should not be blank for Project'
    assert output[:partners].to_json.include?('University of York'),
           'University of York partner not among partners for Project'
  end

  def test_output_attributes_for_phases
    refute projects(:maximum_length_values_project).phases.blank?, 'Project should have a phase'
    output = projects(:maximum_length_values_project).output_attributes
    refute output[:phases].blank?, 'Phase should not be blank for Project'
    assert output[:phases].to_json.include?('First phase'), 'First phase not among phases for Project'
  end

  def test_save_published_version_for_funnelback
    project = projects(:test_save_published_version_for_funnelback_project)
    assert project.valid?, 'Project should be valid'
    assert project.content_item.published_item_json.blank?, 'Should not yet have published_item_json'

    # Check that an update doesn't set the published_item_json
    project.project_overview = 'Overview update 1'
    project.save!
    project = Project.find(project.id)
    assert_nil project.content_item.published_item_json, 'Should not yet have published_item_json'

    # Publish and check it sets the published_item_json
    project.project_overview = 'Overview update 2'
    project.content_item.published!
    project.save!
    project = Project.find(project.id)
    refute_nil project.content_item.published_item_json, 'Should have published_item_json'

    # Change the title so we can check that the url_path is saved correctly in the published_item_json
    project.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    project.content_item.published!
    project.save!
    project = Project.find(project.id)
    refute_nil project.content_item.published_item_json, 'Should have published_item_json'

    # Check that published_item_json is JSON
    assert_kind_of Hash, JSON.parse(project.content_item.published_item_json),
                   'published_item_json could not be parsed as JSON'

    # Check that published_item_json fields match the object
    json_values = JSON.parse(project.content_item.published_item_json)
    assert_equal project.content_item.title, json_values['title'], "published_item_json doesn't match object"
    assert_equal project.content_item.url_path, json_values['url_path'], "published_item_json doesn't match object"
    assert_equal project.content_item.summary, json_values['summary'], "published_item_json doesn't match object"
    assert_equal project.subtype, json_values['core_data']['subtype'], "published_item_json doesn't match object"
    assert_equal project.project_overview, json_values['core_data']['project_overview'],
                 "published_item_json doesn't match object"
    assert_equal project.partners.first.attributes, json_values['core_data']['partners'][0],
                 "published_item_json doesn't match nested object"
  end
end
