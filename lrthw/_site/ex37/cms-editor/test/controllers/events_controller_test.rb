require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_event_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_event_content_item).id
    event_id = events(:for_test_unauthorized_deletion_event).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Event.find(event_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: event_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil Event.find(event_id)
  end
end
