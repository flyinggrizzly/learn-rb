require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  def setup
    @group = Group.find(organisations(:research_group))
  end

  def test_group_valid
    assert @group.valid?
  end

  def test_group_has_users
    assert @group.respond_to?('group_users')
    refute @group.group_users.blank?, "Research group doesn't have any associated people"
    assert_equal Group.find(organisations(:research_group)).name, @group.group_users.first.groups.first.name
  end

  def test_group_has_content
    refute @group.content_items.blank?, 'Research group has no content'
    assert organisations(:research_group).content_items.include? content_items(:marketing_team_content_item)
  end

  def test_group_name_is_unique
    dupe_group = Group.new
    dupe_group.organisation = organisations(:university_of_bath)
    refute dupe_group.valid?
    dupe_group.name = 'Research group'
    refute dupe_group.valid?
    dupe_group.name = 'Another group'
    assert dupe_group.valid?
  end

  def test_group_name_and_type
    assert_equal 'Research group - Group', @group.name_and_type
  end
end
