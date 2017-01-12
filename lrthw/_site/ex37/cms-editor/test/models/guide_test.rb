require 'test_helper'

# Test the validations for Guide
class GuideTest < ActiveSupport::TestCase
  def setup
    @guide = guides(:text_limit_guide)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of Guide, @guide, 'Should be a Guide'
    assert Guide.method_defined?(:published_version), 'Guide should include CanHavePublishingMetadataHooks'
    assert defined?(@guide.last_published_version), 'Guide should have a last_published_version field'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @guide.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @guide.content_item.published!
    @guide.save!
    assert_equal @guide.content_item.url_path,
                 JSON.parse(@guide.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_cta_concern_included
    assert Guide.include?(CanHaveCallToAction), 'CanHaveCallToAction concern should have been included'
  end

  def test_featured_image_concern_included
    assert Guide.include?(CanHaveFeaturedImage), 'CanHaveFeaturedImage concern should have been included'
  end

  def test_valid
    assert guides(:tea_making_guide).valid?
  end

  def test_invalid_detailed_guide
    refute guides(:invalid_detailed_guide).valid?, 'Detailed guide should have at least 2 sections'
  end

  def test_detailed_guide_valid
    assert guides(:detailed_tea_making_guide).valid?
  end

  def test_both_call_to_action_bits_set
    no_cta_guide = guides(:invalid_cta_guide)
    refute no_cta_guide.valid?

    # Have label but invalid url
    no_cta_guide.call_to_action_type = 'url'
    no_cta_guide.call_to_action_label = 'I have a CTA label'
    no_cta_guide.call_to_action_content = 'this is not a URL'
    refute no_cta_guide.valid?

    # valid
    no_cta_guide.call_to_action_type = 'url'
    no_cta_guide.call_to_action_label = 'I have both a CTA label and a URL'
    no_cta_guide.call_to_action_content = 'http://www.batman.com'
    assert no_cta_guide.valid?
  end

  def test_valid_length
    assert @guide.valid?, 'Guide should have been valid'
  end

  def test_output_for_publishing
    output = @guide.output_attributes
    assert @guide.content_item.published?
    refute output['call_to_action_label'].blank?, 'Output for redis for published version of guide not available'
    assert_equal output['object_title'], 'BC9x7zvbS0UbbvhvXtDHmKoY9rAg9kOjr2Bv31h1aP85J4oBbL1CezBbPKk67rq2yfgt6cQKOJlZ1N3sB2jLpNUUFZn3MIRJE1k15BU5yOsGFCNZeyRMl9LEEnfQ43IUGQZBSmkSEJIJXwp74uNHIqMxp9I4H8AQ'
  end

  def test_output_for_sections
    refute @guide.sections.blank?, 'Guide should have sections'
    output = @guide.output_attributes
    refute output[:sections].blank?, 'Sections should not be blank for Guide in output'
  end
end
