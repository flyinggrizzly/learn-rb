require 'test_helper'

class GuidesControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_guide_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_guide_content_item).id
    guide_id = guides(:for_test_unauthorized_deletion_guide).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Guide.find(guide_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: guide_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil Guide.find(guide_id)
  end
end
