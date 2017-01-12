require 'test_helper'

class AnnouncementTest < ActiveSupport::TestCase
  def setup
    @announcement = announcements(:maximum_length_announcement)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of Announcement, @announcement, 'Should be a Announcement'
    assert Announcement.method_defined?(:published_version), 'Announcement should include CanHavePublishingMetadataHooks'
    assert defined?(@announcement.last_published_version), 'Announcement should have a last_published_version field'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @announcement.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @announcement.content_item.published!
    @announcement.save!
    assert_equal @announcement.content_item.url_path,
                 JSON.parse(@announcement.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_cta_concern_included
    assert Announcement.include?(CanHaveCallToAction), 'CanHaveCallToAction concern should have been included'
  end

  def test_featured_image_concern_included
    assert Announcement.include?(CanHaveFeaturedImage), 'CanHaveFeaturedImage concern should have been included'
  end

  def test_valid
    assert @announcement.valid?, 'Announcement should have been valid'
  end

  def test_featured_image_validation
    refute announcements(:missing_featured_image_alt_announcement).valid?, 'Announcement should have failed validation'
    refute announcements(:missing_featured_image_caption_announcement).valid?, 'Announcement should have failed validation'
  end

  def test_object_validation
    refute announcements(:missing_object_title_announcement).valid?, 'Announcement should have failed validation'
    refute announcements(:missing_object_embed_code_announcement).valid?, 'Announcement should have failed validation'
  end

  def test_invalid_email
    refute announcements(:invalid_email_announcement).valid?, 'Announcement should have failed validation'
  end

  def test_invalid_phone
    refute announcements(:invalid_phone_announcement).valid?, 'Announcement should have failed validation'
  end

  def test_output_for_redis
    output = @announcement.output_attributes
    refute output['body_content'].blank?
    assert_includes output['contact_phone'], '11111111111111111111111111'
  end

  def test_internal_url
    assert announcements(:internal_cta_announcement).valid?, 'Announcement should have been valid'
    assert announcements(:internal_full_url_cta_announcement).valid?, 'Announcement should have been valid'
    assert announcements(:external_full_url_cta_announcement).valid?, 'Announcement should have been valid'

    refute announcements(:internal_invalid_cta_announcement).valid?, 'Announcement should not have been valid'
  end
end
