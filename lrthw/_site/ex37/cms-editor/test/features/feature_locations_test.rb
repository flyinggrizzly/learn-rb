require 'test_helper'

# Test Announcement actions
class FeatureLocationTest < Capybara::Rails::TestCase
  def setup
    # Bypass CAS Single Sign On for testing
    CASClient::Frameworks::Rails::Filter.fake('if243')

    # Use webkit driver in Capybara
    Capybara.current_driver = :webkit

    # Block unknown urls
    Capybara.page.driver.block_unknown_urls

    @additional_info_long_copy = "gLDu4Vuwxrf12aTP3xBptL\r\n4HX6PnXE122F9crXZwKxbAHIvgHhGMy9KqGvw6MGpAJTJvxIlNFPbDts0C1Y06XgxgQn4y4w3kXwo1tErtXh4ui3l4qbFgKAyqV0KlMXqoo9ywuZja8HWRv6Yh9xcLxcMrmkoz5L1pZAUJcM2F3I9oGFQMZ4NP27blRxUckJGpXwY1wnBiRbMNrjinV1J6LWgpbDw79vmci1rWR8Thwmk937ivxjcz5saWsxlH1iTFC4mqPFTNGJiC7PBKthyGsDS4VPSPoASIpgMSP4mzp8rTBKAe2TleiHe7Vcya7eQba5O226sPT6R287BCVU5RaAHLSgGc7PpI8nDY0sKQcPtGPSrUPfDvN0bnvrQj4s0kgPlBLDnXifKbrmgZrCtqI86gHH5LjCbslRKgoH4uxJ4KbmgxcByp2LybCooHhUbhaleUqaV63JUmyfuh6C6SxOn6fJV0jM91mhVEs2DsFsfh1WexUbybaoJ944n3KxVUoVx3PKbfvT2PeyYABGkIFTsPNNMTIxDPESt1uYofuBcoErgwO0WFr1Oyt83PzZTv7EPWaUFVnrI7hQi3QYQx8HybRsYvpuBfXi9eazkMroujgGeyjZeeFr6lCMHx1xKAc6ccHjMN6uYx3EIi39qgBWIsaD1wjzStpYSO1lwTqvNSBT1HgKXSboT0QNRDElN0EnbBAeLg8rJR4BJNJemBCSORKISj9cD6rhzn4O3fvyaymRuRsLwSH0qTGvNELOeK5Xcs4ZtOaUjygjenTtfV4G8A1JtEDtWbI17uWf0a62ZTBRul7oHyKbzFXcBcjWuAhm5CW5C2ItsZL7Klpx4xS29HnJPYOEsFtQmOFEWj7Z7yy0C1rQ4rlN9sBA6rwvIjzfySGTV3DVEppFBoP6SGNBjJlunvXzq896lscCFsPrXzpXI6zvVLteNph23tOcC7R3nuLXBh0pS6E11VCoKxvHmn6ILoo6jPRSZx6Y"
  end

  def test_add_new_location
    visit new_location_path

    assert page.has_content?('New location'), 'Screen for creating a new location not rendered properly'

    assert fill_in('location_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('location_content_item_attributes_i_need', with: 'to create a location'), "Couldn't set i_need field"
    assert fill_in('location_content_item_attributes_so_that', with: 'I can test whether the form is ok'), "Couldn't set so_that field"
    assert fill_in('location_content_item_attributes_title', with: 'Brand new location'), "Couldn't set title field"
    assert fill_in('location_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"

    assert choose('location_subtype_campus'), 'Could not choose campus subtype'
    assert choose('location_on_off_campus_on_campus'), 'Could not choose campus location'
    assert fill_in('location_building', with: 'Wessex House'), "Couldn't fill in building"
    assert fill_in('location_room', with: '4.16'), "Couldn't fill in room"
    assert fill_in('location_map_embed_code', with: 'Embed code'), "Couldn't fill in map_embed_code"

    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_delete_location
    visit delete_path
    assert page.has_content?('For test deletion location'), 'Location to be deleted is missing'

    content_item_id = content_items(:for_test_deletion_location_content_item).id
    location_id = locations(:for_test_deletion_location).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Location.find(location_id)

    # Delete the content item
    assert find("#item-#{content_item_id} td form input").click
    assert_equal delete_path, page.current_path

    assert page.has_no_content?('For test deletion location'), 'Location not deleted'

    # Check all parts are gone
    assert_raise(ActiveRecord::RecordNotFound) { ContentItem.find(content_item_id) }
    assert_raise(ActiveRecord::RecordNotFound) { Location.find(location_id) }
  end

  def test_should_allow_enough_newlines
    visit new_location_path

    assert page.has_content?('New location'), 'Screen for creating a new location not rendered properly'

    assert fill_in('location_content_item_attributes_as_a', with: 'Testing robot'), "Couldn't set as_a field"
    assert fill_in('location_content_item_attributes_i_need', with: 'to create an location with lots of newlines'), "Couldn't set i_need field"
    assert fill_in('location_content_item_attributes_so_that', with: 'I can test whether the validation is ok'), "Couldn't set so_that field"
    assert fill_in('location_content_item_attributes_title', with: 'Location with lots of newlines'), "Couldn't set title field"
    assert fill_in('location_content_item_attributes_summary', with: 'blah'), "Couldn't set summary field"

    assert choose('location_subtype_campus'), 'Could not choose campus subtype'
    assert choose('location_on_off_campus_on_campus'), 'Could not choose campus location'
    assert fill_in('location_building', with: 'Wessex House'), "Couldn't fill in building"
    assert fill_in('location_room', with: '4.16'), "Couldn't fill in room"
    assert fill_in('location_map_embed_code', with: 'Embed code'), "Couldn't fill in map_embed_code"

    assert fill_in('location_additional_information', with: @additional_info_long_copy), "Couldn't fill in additional info with long copy"

    assert click_button(I18n.t('shared.status_buttons.save_close'))

    assert_equal root_path, page.current_path
    assert page.has_content?(I18n.t('action_messages.new_save')), 'Saving did not complete properly'
  end

  def test_status_does_not_change_on_validation_error
    location = locations(:test_status_does_not_change_on_validation_error_location)
    visit edit_location_path(location.id)

    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
    assert assert fill_in('location_contact_email', with: 'Blah blah blah'), "Couldn't fill in Contact email"
    assert click_button(I18n.t('shared.status_buttons.publish'))

    assert page.has_no_content?('Published.'), "Page status should not say it's now published!"
    assert page.has_content?('Draft.'), "Page doesn't say that status is draft"
  end
end
