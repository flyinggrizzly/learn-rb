require 'test_helper'

class CampaignsControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_campaign_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_campaign_content_item).id
    campaign_id = campaigns(:for_test_unauthorized_deletion_campaign).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Campaign.find(campaign_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: campaign_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil Campaign.find(campaign_id)
  end
end
