require 'test_helper'

class PublicationsControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_publication_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_publication_content_item).id
    publication_id = publications(:for_test_unauthorized_deletion_publication).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Publication.find(publication_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: publication_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil Publication.find(publication_id)
  end
end
