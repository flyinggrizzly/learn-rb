class TeamMembership < ActiveRecord::Base
  belongs_to :team_profile
  belongs_to :person_profile

  has_paper_trail

  # Order must be a positive integer
  validates :member_order, numericality: { greater_than_or_equal_to: 1 }, allow_nil: true

  # List them in the order previously specified by the user
  default_scope { order('member_order ASC') }
end
