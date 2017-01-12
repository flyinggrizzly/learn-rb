require 'test_helper'

class SubsetTest < ActiveSupport::TestCase
  def test_subset_valid
    assert subsets(:text_limit_team_profile_subset).valid?, 'Max lengths should be valid'
  end

  def test_invalid_subset
    refute subsets(:invalid_subset).valid?, 'Missing title and membership from subset should be invalid'
  end
end
