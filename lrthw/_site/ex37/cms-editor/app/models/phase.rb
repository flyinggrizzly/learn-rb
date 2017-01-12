# Phase object, used in Project
class Phase < ActiveRecord::Base
  include CanStripCarriageReturns

  belongs_to :project
  has_paper_trail

  # Validate presence
  validates :title, :summary, presence: true

  # Ensure start date is before the end date
  validates :end, date: { after: :start }, allow_blank: true

  # Validate length
  validates :budget,
            length: { maximum: 65 }
  validates :title,
            length: { maximum: 160 }
  validates :summary,
            length: { maximum: 6_000 }

  # Make sure there is no pound sign (£) in the budget field
  validates :budget, format: { without: /£/, message: :without_pound_sign }

  default_scope { order('id ASC') }
end
