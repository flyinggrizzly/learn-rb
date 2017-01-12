require 'test_helper'

# Test that associations are correctly configured for Organisation
class OrganisationTest < ActiveSupport::TestCase
  def setup
    @org = organisations(:university_of_bath)
  end

  def test_org_has_users
    @org.org_users << users(:cms_test_user)
    @org.save
    refute @org.org_users.blank?, 'University of Bath doesn\'t have any associated people'
    assert_equal organisations(:university_of_bath).name, @org.org_users.first.organisation.name
  end

  def test_org_has_content
    @org.content_items << content_items(:marketing_team_content_item)
    @org.save
    refute @org.content_items.blank?, 'University of Bath has no content'
    assert organisations(:university_of_bath).content_items.include? content_items(:marketing_team_content_item)
  end

  def test_org_name_is_unique
    dupe_org = Organisation.new
    refute dupe_org.valid?
    dupe_org.name = 'University of Bath'
    refute dupe_org.valid?
    dupe_org.name = 'Another org'
    assert dupe_org.valid?
  end

  def test_org_name_and_type
    assert_equal 'University of Bath', @org.name_and_type
    assert_equal 'Science - Department', organisations(:science).name_and_type
  end
end
