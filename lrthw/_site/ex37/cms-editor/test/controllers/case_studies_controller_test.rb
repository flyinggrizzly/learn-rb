require 'test_helper'

class CaseStudiesControllerTest < ActionController::TestCase
  # Authorized deletion tested in feature test
  def test_unauthorized_case_study_delete
    CASClient::Frameworks::Rails::Filter.fake('cms-test-editor')

    content_item_id = content_items(:for_test_unauthorized_deletion_case_study_content_item).id
    case_study_id = case_studies(:for_test_unauthorized_deletion_case_study).id

    # Check all parts of the content item exist
    refute_nil ContentItem.find(content_item_id)
    refute_nil CaseStudy.find(case_study_id)

    # Delete method with spoof authentication set
    delete(:destroy, { id: case_study_id }, user_authenticated: true)

    # Check it hasn't been deleted
    refute_nil ContentItem.find(content_item_id)
    refute_nil CaseStudy.find(case_study_id)
  end
end
