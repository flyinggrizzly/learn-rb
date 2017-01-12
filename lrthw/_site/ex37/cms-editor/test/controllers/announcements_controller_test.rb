require 'test_helper'

class AnnouncementsControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_announcement_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_announcement_content_item).id
    announcement_id = announcements(:for_test_unauthorized_deletion_announcement).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Announcement.find(announcement_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: announcement_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil Announcement.find(announcement_id)
  end
end
