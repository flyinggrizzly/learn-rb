require 'test_helper'

class LocationsControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_location_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_location_content_item).id
    location_id = locations(:for_test_unauthorized_deletion_location).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Location.find(location_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: location_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil Location.find(location_id)
  end
end
