class Subset < ActiveRecord::Base
  belongs_to :team_profile
  has_paper_trail

  # Validates presence
  validates :membership, presence: true

  # Validates length
  validates :title,
            length: { maximum: 65 }
  validates :membership,
            length: { maximum: 50_000 }

  default_scope { order('id ASC') }
end
