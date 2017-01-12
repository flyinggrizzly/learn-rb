require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  def setup
    @campaign = campaigns(:maximum_length_values_campaign)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of Campaign, @campaign, 'Should be a Campaign'
    assert Campaign.method_defined?(:published_version), 'Campaign should include CanHavePublishingMetadataHooks'
    assert defined?(@campaign.last_published_version), 'Campaign should have a last_published_version field'
  end

  def test_featured_image_concern_included
    assert Campaign.include?(CanHaveFeaturedImage), 'CanHaveFeaturedImage concern should have been included'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @campaign.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @campaign.content_item.published!
    @campaign.save!
    assert_equal @campaign.content_item.url_path,
                 JSON.parse(@campaign.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_valid
    assert @campaign.valid?,
           'Maximum lengths should have been valid - has someone reduced a length?'
  end

  def test_missing_benefit
    refute campaigns(:missing_benefit_campaign).valid?, 'benefit should be required'
  end

  def test_missing_status
    refute campaigns(:missing_status_campaign).valid?, 'status should be required'
  end

  def test_missing_start
    refute campaigns(:missing_start_campaign).valid?, 'start should be required'
  end

  def test_missing_end
    refute campaigns(:missing_end_campaign).valid?, 'end should be required'
  end

  def test_missing_featured_image_caption
    refute campaigns(:missing_featured_image_caption_campaign).valid?, 'featured_image_alt should be required'
  end

  def test_missing_featured_image_alt
    refute campaigns(:missing_featured_image_alt_campaign).valid?, 'featured_image_alt should be required'
  end

  def test_invalid_featured_image
    refute campaigns(:invalid_featured_image_campaign).valid?, 'featured_image should be a valid url'
  end

  def test_invalid_contact_email
    refute campaigns(:invalid_contact_email_campaign).valid?, 'contact_email should be required'
  end

  def test_invalid_contact_phone
    refute campaigns(:invalid_contact_phone_campaign).valid?, 'contact_phone should be required'
  end

  def test_start_after_end
    refute campaigns(:start_after_end_campaign).valid?, 'end date should be after start date'
  end

  def test_output_attributes_for_partners
    refute @campaign.partners.blank?, 'Campaign should have a partner'
    output = @campaign.output_attributes
    refute output[:partners].blank?, 'Partner should not be blank for Campaign'
    assert output[:partners].to_json.include?(partners(:saatchi_saatchi).name),
           'Saatchi and Saatchi partner not among partners for Campaign'
  end

  def test_output_attributes_for_benefits
    refute @campaign.benefits.blank?, 'Campaign should have a benefit'
    output = @campaign.output_attributes
    refute output[:benefits].blank?, 'Benefit should not be blank for Campaign'
    assert output[:benefits].to_json.include?(benefits(:campaign_benefit).description),
           'First benefit not among benefits for Campaign'
  end

  def test_output_for_preview
    # Fetch the draft
    campaign  = campaigns(:test_campaign_output_for_preview)
    refute_nil campaign

    # Publish it to ensure we trigger Papertrail
    campaign.content_item.status = ContentItem.statuses[:published]
    campaign.save!

    # Check there's a published_version
    refute campaign.published_version.blank?
    assert_equal campaign.published_version, campaign
    assert_equal campaign.output_attributes['supporting_information'], campaign.supporting_information

    # Change values and set For Review
    refute_nil campaign.content_item
    campaign.content_item.summary = 'Summary after preview'
    campaign.supporting_information = 'This is what I say AFTER Review'
    campaign.content_item.status = ContentItem.statuses[:review]
    campaign.save

    # Check that output_attributes isn't the same as last published version attributes
    refute campaign.output_attributes.blank?
    assert_equal campaign.supporting_information, campaign.output_attributes['supporting_information']
    refute_equal campaign.versions[campaign.last_published_version].reify(has_one: true, has_many: true).supporting_information,
                 campaign.output_attributes['supporting_information']
  end
end
