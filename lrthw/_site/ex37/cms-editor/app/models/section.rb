class Section < ActiveRecord::Base
  include CanStripCarriageReturns

  belongs_to :guide
  has_paper_trail

  # Validates presence
  validates :title, :body_content, presence: true

  # Validates length
  validates :title,
            length: { maximum: 65 }
  validates :body_content,
            length: { maximum: 50_000 }

  default_scope { order('id ASC') }
end
