require 'test_helper'

class ServiceStartsControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_service_start_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_service_start_content_item).id
    service_start_id = service_starts(:for_test_unauthorized_deletion_service_start).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil ServiceStart.find(service_start_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: service_start_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil ServiceStart.find(service_start_id)
  end
end
