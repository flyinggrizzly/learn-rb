require 'test_helper'

class OrganisationLandingPagesControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_organisation_landing_page_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_organisation_landing_page_content_item).id
    organisation_landing_page_id = organisation_landing_pages(:for_test_unauthorized_deletion_organisation_landing_page).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil OrganisationLandingPage.find(organisation_landing_page_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: organisation_landing_page_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil OrganisationLandingPage.find(organisation_landing_page_id)
  end
end
