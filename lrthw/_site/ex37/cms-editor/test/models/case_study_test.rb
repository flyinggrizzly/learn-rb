require 'test_helper'

class CaseStudyTest < ActiveSupport::TestCase
  def setup
    @case_study = case_studies(:maximum_length_case_study)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of CaseStudy, @case_study, 'Should be a CaseStudy'
    assert CaseStudy.method_defined?(:published_version), 'CaseStudy should include CanHavePublishingMetadataHooks'
    assert defined?(@case_study.last_published_version), 'CaseStudy should have a last_published_version field'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @case_study.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @case_study.content_item.published!
    @case_study.save!
    assert_equal @case_study.content_item.url_path,
                 JSON.parse(@case_study.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_cta_concern_included
    assert CaseStudy.include?(CanHaveCallToAction), 'CanHaveCallToAction concern should have been included'
  end

  def test_featured_image_concern_included
    assert CaseStudy.include?(CanHaveFeaturedImage), 'CanHaveFeaturedImage concern should have been included'
  end

  def test_valid
    assert @case_study.valid?, 'CaseStudy should have been valid'
  end

  def test_featured_image_validation
    refute case_studies(:missing_featured_image_alt_case_study).valid?, 'CaseStudy should have failed validation'
    refute case_studies(:missing_featured_image_caption_case_study).valid?, 'CaseStudy should have failed validation'
  end

  def test_object_validation
    refute case_studies(:missing_object_title_case_study).valid?, 'CaseStudy should have failed validation'
    refute case_studies(:missing_object_embed_code_case_study).valid?, 'CaseStudy should have failed validation'
  end

  def test_quote_validation
    refute case_studies(:invalid_quote_case_study).valid?, 'CaseStudy should have failed validation'
  end

  def test_invalid_email
    refute case_studies(:invalid_email_case_study).valid?, 'CaseStudy should have failed validation'
  end

  def test_invalid_phone
    refute case_studies(:invalid_phone_case_study).valid?, 'CaseStudy should have failed validation'
  end
end
