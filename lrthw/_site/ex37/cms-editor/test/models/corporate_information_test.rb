require 'test_helper'

class CorporateInformationTest < ActiveSupport::TestCase
  def setup
    @corporate_information = corporate_informations(:maximum_length_corporate_information)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of CorporateInformation, @corporate_information, 'Should be a CorporateInformation'
    assert CorporateInformation.method_defined?(:published_version), 'CorporateInformation should include CanHavePublishingMetadataHooks'
    assert defined?(@corporate_information.last_published_version), 'CorporateInformation should have a last_published_version field'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @corporate_information.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @corporate_information.content_item.published!
    @corporate_information.save!
    assert_equal @corporate_information.content_item.url_path,
                 JSON.parse(@corporate_information.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_cta_concern_included
    assert CorporateInformation.include?(CanHaveCallToAction), 'CanHaveCallToAction concern should have been included'
  end

  def test_featured_image_concern_included
    assert CorporateInformation.include?(CanHaveFeaturedImage), 'CanHaveFeaturedImage concern should have been included'
  end

  def test_valid
    assert @corporate_information.valid?, 'CorporateInformation should have been valid'
  end

  def test_featured_image_validation
    refute corporate_informations(:missing_featured_image_alt_corporate_information).valid?, 'CorporateInformation should have failed validation'
    refute corporate_informations(:missing_featured_image_caption_corporate_information).valid?, 'CorporateInformation should have failed validation'
  end

  def test_object_validation
    refute corporate_informations(:missing_object_title_corporate_information).valid?, 'CorporateInformation should have failed validation'
    refute corporate_informations(:missing_object_embed_code_corporate_information).valid?, 'CorporateInformation should have failed validation'
  end

  # Call to action extensive tests to cover the entire concern
  def test_call_to_action_type_validation
    refute corporate_informations(:test_call_to_action_type_missing_corporate_information).valid?, 'CorporateInformation should have failed validation'
    refute corporate_informations(:test_call_to_action_type_incorrect_corporate_information).valid?, 'CorporateInformation should have failed validation'
  end

  def test_call_to_action_url_validation
    assert corporate_informations(:test_call_to_action_url_valid_corporate_information).valid?, 'CorporateInformation should be valid'
    refute corporate_informations(:test_call_to_action_url_label_missing_corporate_information).valid?, 'CorporateInformation should have failed validation'
    refute corporate_informations(:test_call_to_action_url_label_long_corporate_information).valid?, 'CorporateInformation should have failed validation'
    refute corporate_informations(:test_call_to_action_url_content_missing_corporate_information).valid?, 'CorporateInformation should have failed validation'

    content_long = corporate_informations(:test_call_to_action_url_content_long_corporate_information)
    content_long.call_to_action_content = 'http://www.bath.ac.uk/BC9x7zvbS0UbbvhvXtDHmKoY9rAg9kOjr2Bv31h1aP85J4oBbL1CezBbPKk67rq2yfgt6cQKOJlZ1N3sB2jLpNUUFZn3MIRJE1k15BU5yOsGFCNZeyRMl9LEEnfQ43IUGQZBSmkSEJIJXwp74uNHIqMxp9I4H8AQnfyOx5ZHxsHnmAJqsiABGY7svwY7icqtcZqlDLzNq6qzSBoLlyWweLpQhAMDm8vM72WfrygjSs'
    refute content_long.valid?, 'CorporateInformation should have failed validation'

    refute corporate_informations(:test_call_to_action_url_content_invalid_corporate_information).valid?, 'CorporateInformation should have failed validation'
  end

  def test_call_to_action_email_validation
    assert corporate_informations(:test_call_to_action_email_valid_corporate_information).valid?, 'CorporateInformation should be valid'
    refute corporate_informations(:test_call_to_action_email_label_missing_corporate_information).valid?, 'CorporateInformation should have failed validation'
    refute corporate_informations(:test_call_to_action_email_label_long_corporate_information).valid?, 'CorporateInformation should have failed validation'
    refute corporate_informations(:test_call_to_action_email_content_missing_corporate_information).valid?, 'CorporateInformation should have failed validation'

    content_long = corporate_informations(:test_call_to_action_email_content_long_corporate_information)
    content_long.call_to_action_content = 'abbvhvXtDHmKoY9rAg9kOjr2Bv31h1aP85J4oBbL1CezBbPKk67rq2yfgt6cQKOJlZ1N3sB2jLpNUUFZn3MIRJE1k15BU5yOsGFCNZeyRMl9LEEnfQ43IUGQZBSmkSEJIJXwp74uNHIqMxp9I4H8AQnfyOx5ZHxsHnmAJqsiABGY7svwY7icqtcZqlDLzNq6qzSBoLlyWweLpQhAMDm8vM72WfrygjSJtTWnNmm4sgpmPNewBjDVA@bath.ac.uk'
    refute content_long.valid?, 'CorporateInformation should have failed validation'

    refute corporate_informations(:test_call_to_action_email_content_invalid_corporate_information).valid?, 'CorporateInformation should have failed validation'
  end

  def test_call_to_action_phone_validation
    assert corporate_informations(:test_call_to_action_phone_length_valid_corporate_information).valid?, 'CorporateInformation length should be valid'
    assert corporate_informations(:test_call_to_action_phone_valid_corporate_information).valid?, 'CorporateInformation phone number should be valid'
    refute corporate_informations(:test_call_to_action_phone_label_missing_corporate_information).valid?, 'CorporateInformation should have failed validation'
    refute corporate_informations(:test_call_to_action_phone_label_long_corporate_information).valid?, 'CorporateInformation should have failed validation'
    refute corporate_informations(:test_call_to_action_phone_content_missing_corporate_information).valid?, 'CorporateInformation should have failed validation'

    content_long = corporate_informations(:test_call_to_action_phone_content_long_corporate_information)
    content_long.call_to_action_content = '1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
    refute content_long.valid?, 'CorporateInformation should have failed validation'

    refute corporate_informations(:test_call_to_action_phone_content_invalid_corporate_information).valid?, 'CorporateInformation should have failed validation'
  end

  def test_call_to_action_none_validation
    assert corporate_informations(:test_call_to_action_none_valid_corporate_information).valid?, 'CorporateInformation should be valid'
    refute corporate_informations(:test_call_to_action_none_reason_missing_corporate_information).valid?, 'CorporateInformation should have failed validation'

    content_long = corporate_informations(:test_call_to_action_none_reason_long_corporate_information)
    content_long.call_to_action_content = 'k6OKYubmnAAvh5MRBMIWiZNfpBuJQ1oscrDabfJpAahcj2pmW73xFKmg3C1lzyoqzCGNPFuKprpIGyIhVaJgbtPXpTrRtR0tX8ewQQyc9Hov4U35WHHIAk7bO57QhkiKLfHnwYamW0GV6qFFowz0sM6LnxFUgWriuwsMYJ63KShS5EJrWEciN7NRJBzUzL8U6xbPxJRpnCs0bzluac8jBqMLS30bRBNweiGBk6tYmL4eR54BfuJ6cchFMe8IkgZa'
    refute content_long.valid?, 'CorporateInformation should have failed validation'
  end
  # End CTA tests

  def test_publish_change_to_title_and_body_content
    corp_info = corporate_informations(:test_publish_change_to_title_and_body_content)
    assert corp_info.valid?, 'CorporateInformation should be valid'

    # Publish it
    corp_info.content_item.status = 3
    corp_info.save!
    corp_info = CorporateInformation.find(corp_info.id)
    refute_nil corp_info.published_version, 'There should be a published version'

    # Make an unpublished change
    corp_info.body_content = 'We are saving this as a draft'
    corp_info.content_item.status = 0
    corp_info.save!
    corp_info = CorporateInformation.find(corp_info.id)

    # Publish it again with a title and body_content change
    corp_info.content_item.title = 'Corp info changed'
    new_title = 'We are publishing this with a title and body_content change'
    corp_info.body_content = new_title
    corp_info.content_item.status = 3
    corp_info.save!

    # Check that the body_content has been updated in output_attributes
    # Get it via content_item.core_data the way we do in the publish_message method in ContentItem
    assert_equal corp_info.content_item.core_data.output_attributes['body_content'], new_title,
                 'body_content not changed for publisher'
  end

  def test_output_for_preview
    # Fetch the draft
    corp_info = corporate_informations(:test_corp_info_output_for_preview)
    refute_nil corp_info

    # Publish it to ensure we trigger Papertrail
    corp_info.content_item.status = ContentItem.statuses[:published]
    corp_info.save!

    # Check there's a published_version
    refute corp_info.published_version.blank?
    assert_equal corp_info.published_version, corp_info
    assert_equal corp_info.output_attributes['body_content'], corp_info.body_content

    # Change values and set For Review
    refute_nil corp_info.content_item
    corp_info.content_item.summary = 'Summary after preview'
    corp_info.body_content = 'This is what I say AFTER Review'
    corp_info.content_item.status = ContentItem.statuses[:review]
    corp_info.save

    # Check that output_attributes isn't the same as last published version attributes
    refute corp_info.output_attributes.blank?
    assert_equal corp_info.body_content, corp_info.output_attributes['body_content']
    refute_equal corp_info.versions[corp_info.last_published_version].reify(has_one: true, has_many: true).body_content,
                 corp_info.output_attributes['body_content']
  end
end
