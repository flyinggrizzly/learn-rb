require 'test_helper'
require 'content_type_list_service'

# Test ContentTypeListService
class ContentTypeListServiceTest < ActiveSupport::TestCase
  def setup
  end

  def test_all_content_types
    assert_equal 14, ContentTypeListService.all.size
    assert_includes ContentTypeListService.all, 'OrganisationLandingPage'
  end

  def test_all_without_landing_pages
    assert_equal 12, ContentTypeListService.without_landing_pages.size
    refute_includes ContentTypeListService.without_landing_pages, 'OrganisationLandingPage'
  end
end
