require 'test_helper'

class CorporateInformationsControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_corporate_information_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_corporate_information_content_item).id
    corporate_information_id = corporate_informations(:for_test_unauthorized_deletion_corporate_information).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil CorporateInformation.find(corporate_information_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: corporate_information_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil CorporateInformation.find(corporate_information_id)
  end
end
