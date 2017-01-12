require 'test_helper'

class TeamProfilesControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_team_profile_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_team_profile_content_item).id
    team_profile_id = team_profiles(:for_test_unauthorized_deletion_team_profile).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil TeamProfile.find(team_profile_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: team_profile_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil TeamProfile.find(team_profile_id)
  end
end
