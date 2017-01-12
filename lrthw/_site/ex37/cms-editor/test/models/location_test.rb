require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  def setup
    @location = locations(:maximum_length_on_campus_location)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of Location, @location, 'Should be a Location'
    assert Location.method_defined?(:published_version), 'Location should include CanHavePublishingMetadataHooks'
    assert defined?(@location.last_published_version), 'Location should have a last_published_version field'
  end

  def test_featured_image_concern_included
    assert Location.include?(CanHaveFeaturedImage), 'CanHaveFeaturedImage concern should have been included'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @location.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @location.content_item.published!
    @location.save!
    assert_equal @location.content_item.url_path,
                 JSON.parse(@location.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_maximum_length_on_campus
    assert locations(:maximum_length_on_campus_location).valid?, 'On campus location should have been valid'
  end

  def test_maximum_length_off_campus
    assert locations(:maximum_length_off_campus_location).valid?, 'Off campus location should have been valid'
  end

  def test_missing_on_off_campus
    refute locations(:missing_on_off_campus_location).valid?, 'on_off_campus should be required'
  end

  def test_missing_map_embed_code
    refute locations(:missing_map_embed_code_location).valid?, 'map_embed_code should be required'
  end

  def test_on_campus_validation
    refute locations(:missing_building_location).valid?, 'Location should have failed validation'
  end

  def test_off_campus_validation
    refute locations(:missing_address_1_location).valid?, 'Location should have failed validation'
    refute locations(:missing_town_location).valid?, 'Location should have failed validation'
    refute locations(:missing_postcode_location).valid?, 'Location should have failed validation'
    refute locations(:missing_country_location).valid?, 'Location should have failed validation'
  end

  def test_featured_image_validation
    refute locations(:invalid_featured_image_location).valid?, 'Location should have failed validation'
    refute locations(:missing_featured_image_alt_location).valid?, 'Location should have failed validation'
    refute locations(:missing_featured_image_caption_location).valid?, 'Location should have failed validation'
  end

  def test_email_validation
    refute locations(:invalid_email_location).valid?, 'Location should have failed validation'
  end

  def test_phone_validation
    refute locations(:invalid_phone_location).valid?, 'Location should have failed validation'
  end

  def test_carriage_return_stripped
    long_location = locations(:additional_information_with_carriage_returns)
    assert_includes long_location.additional_information, "\r\n"
    assert long_location.valid?, 'Should be valid after having carriage return stripped'
    assert long_location.additional_information.size <= 1000
    refute_includes long_location.additional_information, "\r", "Carriage return not stripped"
    assert_includes long_location.additional_information, "\n", "Newline was stripped when it shouldn't have been"
  end
end
