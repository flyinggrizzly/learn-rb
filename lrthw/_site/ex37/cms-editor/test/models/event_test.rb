require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def setup
    @event = events(:valid_event)
  end

  def test_can_have_publishing_metadata_hooks_concern_included
    assert_kind_of Event, @event, 'Should be an Event'
    assert Event.method_defined?(:published_version), 'Event should include CanHavePublishingMetadataHooks'
    assert defined?(@event.last_published_version), 'Event should have a last_published_version field'
  end

  def test_featured_image_concern_included
    assert Event.include?(CanHaveFeaturedImage), 'CanHaveFeaturedImage concern should have been included'
  end

  def test_saved_url_path_for_funnelback
    # Change the title and publish so we can check that the new generated url_path is
    # saved correctly in the published_item_json
    @event.content_item.title = 'New title - padded to the maximum length'.ljust(100, ' padding')
    @event.content_item.published!
    @event.save!
    assert_equal @event.content_item.url_path,
                 JSON.parse(@event.content_item.published_item_json)['url_path'],
                 'New url_path not saved in published_item_json'
  end

  def test_valid
    assert @event.valid?, 'Event should have been valid'

    event = events(:maximum_length_values_on_campus_valid)
    assert event.valid?, 'On campus event should have been valid'
    assert_equal 10_000.00, event.price

    event = events(:maximum_length_values_off_campus_valid)
    assert event.valid?, 'Off campus event should have been valid'
  end

  # test validate invalid email
  def test_email_validation
    event_1 = events(:invalid_email_one_event)
    refute event_1.valid?, 'Email should not have been valid'

    event_2 = events(:invalid_email_two_event)
    refute event_2.valid?, 'Email should not have been valid'

    event_3 = events(:invalid_email_ending_period_event)
    refute event_3.valid?, 'Email ending in a period should not have been valid'
  end

  # test validate url
  def test_url_validation
    event = events(:invalid_url_event)
    refute event.valid?, 'URL should not have been valid'
  end

  # test validate phone number
  def test_phone_validation
    event_1 = events(:invalid_phone_event)
    refute event_1.valid?, 'Phone number should not have been valid'

    event_2 = events(:valid_phone_brackets_event)
    assert event_2.valid?, 'Phone number with brackets should be valid'
  end

  # test email present if booking method is set to "email"
  def test_email_if_booking_email
    event = events(:missing_email_if_booking_email_event)
    refute event.valid?, 'Booking email should be required if booking method is "email"'
  end

  # test link present if booking method is set to "booking application" or "website"
  def test_link_if_booking_method
    event_1 = events(:missing_link_if_booking_app_event)
    refute event_1.valid?, 'Booking link should be required if booking method is "booking application"'

    event_2 = events(:missing_link_if_booking_website_event)
    refute event_2.valid?, 'Booking link should be required if booking method is "website"'
  end

  # test price present if there is a charge
  def test_price_if_charge
    event = events(:missing_price_if_charge)
    refute event.valid?, 'Price should be required if charge is true'
  end

  # test end date is after start date
  def test_end_before_start
    event = events(:invalid_end_before_start)
    refute event.valid?, 'End date should be required to be after start date'
  end

  # test venue present if on campus and building is empty
  def test_venue_if_on_campus_building_empty
    event = events(:missing_venue_if_on_campus_building_empty)
    refute event.valid?, 'Venue should be required if on campus and building is empty'
  end

  # test building present if on campus and venue is empty
  def test_building_if_on_campus_venue_empty
    event = events(:missing_building_if_on_campus_venue_empty)
    refute event.valid?, 'Building should be required if on campus and venue is empty'
  end

  # test building present if on campus and room number specified
  def test_building_if_on_campus_room_number_specified
    event = events(:missing_building_if_on_campus_room_number_specified)
    refute event.valid?, 'Building should be required if on campus and room number is specified'
  end

  # test location must be on or off campus
  def test_location_outside_range
    event = events(:location_outside_range)
    refute event.valid?, 'Location should be restricted to fixed options'
  end

  # test off campus fields must be empty if event is on campus
  def test_off_campus_fields_empty_on_campus
    event = events(:invalid_address_1_on_campus)
    refute event.valid?, 'Address 1 should be forced blank if event is on campus'

    event = events(:invalid_address_2_on_campus)
    refute event.valid?, 'Address 2 should be forced blank if event is on campus'

    event = events(:invalid_town_on_campus)
    refute event.valid?, 'Town should be forced blank if event is on campus'

    event = events(:invalid_country_on_campus)
    refute event.valid?, 'Country should be forced blank if event is on campus'

    event = events(:invalid_postcode_on_campus)
    refute event.valid?, 'Postcode should be forced blank if event is on campus'
  end

  # test on campus fields must be empty if event is off campus
  def test_on_campus_fields_empty_off_campus
    event = events(:invalid_venue_off_campus)
    refute event.valid?, 'Venue should be forced blank if event is off campus'

    event = events(:invalid_room_number_off_campus)
    refute event.valid?, 'Room number should be forced blank if event is off campus'

    event = events(:invalid_building_off_campus)
    refute event.valid?, 'Building should be forced blank if event is off campus'
  end
end
