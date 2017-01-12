require 'test_helper'

class ServiceStartTest < ActiveSupport::TestCase
  def setup
    @service_start = service_starts(:maximum_length_service_start)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of ServiceStart, @service_start, 'Should be a ServiceStart'
    assert ServiceStart.method_defined?(:published_version), 'ServiceStart should include CanHavePublishingMetadataHooks'
    assert defined?(@service_start.last_published_version), 'ServiceStart should have a last_published_version field'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @service_start.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @service_start.content_item.published!
    @service_start.save!
    assert_equal @service_start.content_item.url_path,
                 JSON.parse(@service_start.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_cta_concern_included
    assert ServiceStart.include?(CanHaveCallToAction), 'CanHaveCallToAction concern should have been included'
  end

  def test_valid
    assert @service_start.valid?, 'ServiceStart should have been valid'
  end

  def test_usage_instructions_validation
    refute service_starts(:missing_usage_instructions_service_start).valid?, 'ServiceStart should have failed validation'
  end

  def test_invalid_email
    refute service_starts(:invalid_email_service_start).valid?, 'ServiceStart should have failed validation'
  end

  def test_invalid_phone
    refute service_starts(:invalid_phone_service_start).valid?, 'ServiceStart should have failed validation'
  end

  def test_output_attributes_for_guides
    refute service_starts(:maximum_length_service_start).guides.blank?
    output = service_starts(:maximum_length_service_start).output_attributes
    refute output[:guides].blank?, 'Guides should not be blank for Service Start'
    assert output[:guides].to_s.include?('How to make tea'), 'Tea making guide not among Guides for Service Start'
  end

  def test_output_for_preview
    # Fetch the draft
    service_start  = service_starts(:test_service_start_output_for_preview)
    refute_nil service_start

    # Publish it to ensure we trigger Papertrail
    service_start.content_item.status = ContentItem.statuses[:published]
    service_start.save

    # Check there's a published_version
    refute service_start.published_version.blank?
    assert_equal service_start.published_version, service_start
    assert_equal service_start.output_attributes['usage_instructions'], service_start.usage_instructions

    # Change values and set For Review
    refute_nil service_start.content_item
    service_start.content_item.summary = 'Summary after preview'
    service_start.usage_instructions = 'This is what I say AFTER Review'
    service_start.content_item.status = ContentItem.statuses[:review]
    service_start.save

    # Check that output_attributes isn't the same as last published version attributes
    refute service_start.output_attributes.blank?
    assert_equal service_start.usage_instructions, service_start.output_attributes['usage_instructions']
    refute_equal service_start.versions[service_start.last_published_version].reify(has_one: true, has_many: true).usage_instructions,
                 service_start.output_attributes['usage_instructions']
  end
end
