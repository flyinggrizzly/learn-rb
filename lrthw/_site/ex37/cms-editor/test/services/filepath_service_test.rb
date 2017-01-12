require 'test_helper'
require 'filepath_service'

# Test FilepathService
class FilepathServiceTest < ActiveSupport::TestCase
  def setup
  end

  def test_generate_path
    # Generic
    assert_equal 'guides', FilepathService.generate_path('Guide', nil)
    assert_equal 'case-studies', FilepathService.generate_path('CaseStudy', nil)

    # Special cases
    assert_equal 'groups', FilepathService.generate_path('OrganisationLandingPage', 'group')
    assert_equal 'departments', FilepathService.generate_path('OrganisationLandingPage', 'organisation')
    assert_equal 'profiles', FilepathService.generate_path('PersonProfile', nil)
    assert_equal 'services', FilepathService.generate_path('ServiceStart', nil)
    assert_equal 'teams', FilepathService.generate_path('TeamProfile', nil)
  end

  def test_format_filename
    project = projects(:test_filename_format_project)
    filename = FilepathService.format_filename(project)
    assert_equal 'this-should-become-a-filename', filename
  end

  def test_generated_url_has_no_special_chars
    pp = person_profiles(:andre_muller_profile)
    url_path = FilepathService.generate_url_path(pp)
    assert_equal '/profiles/maitriser-andre-a-muller-50', url_path

    pp = person_profiles(:acute_profile)
    url_path = FilepathService.generate_url_path(pp)
    assert_equal '/profiles/master-acute', url_path
  end

  def test_generated_url_has_no_hyphen_on_apostrophe
    team = team_profiles(:vice_chancellors_group)

    url_path = FilepathService.generate_url_path(team)
    assert_equal '/teams/vice-chancellors-group', url_path
  end
end
