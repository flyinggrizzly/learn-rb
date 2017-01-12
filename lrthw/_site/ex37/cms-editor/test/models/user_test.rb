require 'test_helper'

# Check User model configurations
class UserTest < ActiveSupport::TestCase
  def test_find_or_create_user
    # Dan is not used anywhere else in the test suite, so this is initial creation
    user = User.find_or_create_user('dsd28')
    assert_equal 'Daniel', user.first_name
    assert_equal 'Dineen', user.last_name
    assert_equal 'Dan Dineen', user.display_name
    assert_equal 1_125_235, user.person_id

    # User should not have any permissions set since they have never logged in
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    refute user.contributor?, 'User should not be a contributor'
  end

  def test_unique_usernames
    username = 'thesame'
    first_user = User.new(username: username)
    first_user.organisation = organisations(:mar_comms)
    first_user.save
    assert first_user.valid?, 'User should have been valid'

    duplicate_user = User.new(username: username)
    refute duplicate_user.valid?, 'User with identical username should not be valid'

    duplicate_user = User.new(username: username.upcase)
    refute duplicate_user.valid?, 'User with identical username except case should not be valid'
  end

  def test_user_in_an_organisation
    test_user = User.new(username: 'test-user')
    test_user.organisation = organisations(:mar_comms)
    assert test_user.valid?
    refute test_user.organisation.blank?
  end

  def test_set_user_as_admin
    user = users(:cms_test_user)
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    refute user.contributor?, 'User should not be a contributor'

    user.admin!
    assert user.admin?, 'User should be an admin'
    assert user.editor?, 'User should be an editor'
    assert user.author?, 'User should be an author'
    assert user.contributor?, 'User should be a contributor'
  end

  def test_set_user_as_editor
    user = users(:cms_test_user)
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    refute user.contributor?, 'User should not be a contributor'

    user.editor!
    refute user.admin?, 'User should not be an admin'
    assert user.editor?, 'User should be an editor'
    assert user.author?, 'User should be an author'
    assert user.contributor?, 'User should be a contributor'
  end

  def test_set_user_as_author
    user = users(:cms_test_user)
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    refute user.contributor?, 'User should not be a contributor'

    user.author!
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    assert user.author?, 'User should be an author'
    assert user.contributor?, 'User should be a contributor'
  end

  def test_set_user_as_contributor
    user = users(:cms_test_user)
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    refute user.contributor?, 'User should not be a contributor'

    user.contributor!
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    assert user.contributor?, 'User should be a contributor'
  end

  def test_set_user_no_permissions
    user = users(:cms_test_user)
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    refute user.contributor?, 'User should not be a contributor'

    user.admin!
    assert user.admin?, 'User should be an admin'
    assert user.editor?, 'User should be an editor'
    assert user.author?, 'User should be an author'
    assert user.contributor?, 'User should be a contributor'

    user.no_permissions!
    refute user.admin?, 'User should not be an admin'
    refute user.editor?, 'User should not be an editor'
    refute user.author?, 'User should not be an author'
    refute user.contributor?, 'User should not be a contributor'
  end

  def test_add_user_to_associated_org
    user = users(:cms_test_user)
    ao = organisations(:science)
    user.associated_orgs << ao
    user.save

    assert organisations(:science).associated_org_users.include?(user)
  end
end
