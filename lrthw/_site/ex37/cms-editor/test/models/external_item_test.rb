require 'test_helper'

class ExternalItemTest < ActiveSupport::TestCase
  def setup
    @external_item = external_items(:maximum_length_values_external_item)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of ExternalItem, @external_item, 'Should be an ExternalItem'
    assert ExternalItem.method_defined?(:published_version), 'ExternalItem should include CanHavePublishingMetadataHooks'
    assert defined?(@external_item.last_published_version), 'ExternalItem should have a last_published_version field'
  end

  def test_featured_image_concern_included
    assert ExternalItem.include?(CanHaveFeaturedImage), 'CanHaveFeaturedImage concern should have been included'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @external_item.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @external_item.content_item.published!
    @external_item.save!
    assert_equal @external_item.content_item.url_path,
                 JSON.parse(@external_item.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_maximum_length_valid
    assert @external_item.valid?, 'Maximum length values external_item should have been valid'
  end

  def test_missing_external_url
    refute external_items(:missing_external_url_external_item).valid?, 'external_url should be required'
  end

  def test_url_validation
    refute external_items(:invalid_url_external_item).valid?, 'external_url should not have been valid'
    refute external_items(:invalid_university_url_external_item).valid?, 'external_url should not have been valid'
    refute external_items(:invalid_university_content_publisher_url_external_item).valid?,
           'external_url should not have been valid'
    refute external_items(:invalid_external_url_external_item).valid?, 'external_url should not have been valid'
  end

  def test_featured_image_validation
    refute external_items(:invalid_featured_image_external_item).valid?, 'ExternalItem should have failed validation'
    refute external_items(:missing_featured_image_alt_external_item).valid?,
           'ExternalItem should have failed validation'
    refute external_items(:missing_featured_image_caption_external_item).valid?,
           'ExternalItem should have failed validation'
  end
end
