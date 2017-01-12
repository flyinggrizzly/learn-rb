require 'test_helper'

# Test actions on login create a user and associate to Organisation
class FeatureOrganisationTest < Capybara::Rails::TestCase
  def setup
    # Have to test with a real person as cms-test-user doesn't come up in Person Finder
    CASClient::Frameworks::Rails::Filter.fake('if243')
  end

  def test_associate_user_and_org
    visit root_path
    uob = Organisation.find_by_name('University of Bath')
    refute uob.blank?
    refute uob.org_users.blank?, 'User not added to University of Bath org on login'
    assert_equal organisations(:university_of_bath).name, User.find_by(username: 'if243').organisation.name
  end
end
