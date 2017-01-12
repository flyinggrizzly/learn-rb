require 'test_helper'

class ExternalItemsControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_external_item_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:test_unauthorized_deletion_external_item_content_item).id
    external_item_id = external_items(:test_unauthorized_deletion_external_item).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil ExternalItem.find(external_item_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: external_item_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil ExternalItem.find(external_item_id)
  end
end
