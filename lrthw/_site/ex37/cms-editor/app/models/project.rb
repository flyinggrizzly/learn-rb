class Project < ActiveRecord::Base
  include CanStripCarriageReturns
  include CanHaveContact
  include CanHaveFeaturedImage
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_many :phases, dependent: :destroy
  has_many :partners, dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true
  accepts_nested_attributes_for :phases, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :partners, allow_destroy: true, reject_if: :all_blank

  # Validate presence
  validates :subtype, :status, :project_overview, presence: true

  # Validate presence and must be one of list
  validates :subtype, inclusion: { in: %w(research_project services_project) }
  validates :status, inclusion: { in: %w(planned active complete) }

  # Validate length
  validates :budget,
            length: { maximum: 65 }
  validates :object_title,
            length: { maximum: 160 }
  validates :object_embed_code,
            length: { maximum: 1_000 }
  validates :project_overview,
            length: { maximum: 6_000 }

  # Ensure start date is before the end date
  validates :end, date: { after: :start }, allow_blank: true

  # Ensure there is a object_title if there is an object_embed_code and vice versa
  validates :object_title, presence: { if: :object_embed_code? }
  validates :object_embed_code, presence: { if: :object_title? }

  # Make sure there is no pound sign (£) in the budget field
  validates :budget, format: { without: /£/, message: :without_pound_sign }

  def output_attributes
    output = attributes
    output['status'] = I18n.t("projects.status_output_#{status}")
    output[:phases] = phases(&:phase)
    output[:partners] = partners(&:partner)
    output
  end
end
