require 'test_helper'

class ProjectsControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_project_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_project_content_item).id
    project_id = projects(:for_test_unauthorized_deletion_project).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil Project.find(project_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: project_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil Project.find(project_id)
  end
end
