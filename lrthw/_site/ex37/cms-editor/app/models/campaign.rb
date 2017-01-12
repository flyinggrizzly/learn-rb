class Campaign < ActiveRecord::Base
  include CanStripCarriageReturns
  include CanHaveContact
  include CanConstructUrl
  include CanHaveFeaturedImage
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_many :benefits, dependent: :destroy
  has_many :partners, dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true
  accepts_nested_attributes_for :benefits, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :partners, allow_destroy: true, reject_if: :all_blank

  # Validate presence
  validates :subtype, :status, :start, :end, presence: true

  # Validate presence and must be one of list
  validates :subtype, inclusion: { in: %w(campus_campaign public_campaign) }
  validates :status, inclusion: { in: %w(open closed) }

  # Validate length
  validates :supporting_information,
            length: { maximum: 1_000 }

  # Ensure start date is before the end date
  validates :end, date: { after: :start }, allow_blank: true

  # Make sure that there is at least one benefit
  validate :require_one_benefit

  def output_attributes
    output = attributes
    output[:partners] = partners(&:partner)
    output[:benefits] = benefits(&:benefit)
    output
  end

  private

  def require_one_benefit
    errors.add(:base, 'You must have at least one benefit') if benefits.empty?
  end
end
