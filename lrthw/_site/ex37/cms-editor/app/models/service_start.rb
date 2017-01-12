class ServiceStart < ActiveRecord::Base
  include CanHaveCallToAction
  include CanStripCarriageReturns
  include CanHaveContact
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_and_belongs_to_many :guides
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true

  # Validate presence
  validates :usage_instructions, presence: true

  # Validate length
  validates :usage_instructions,
            length: { maximum: 500 }

  def output_attributes
    output = attributes
    output[:guides] = guides_for_output unless guides.blank?
    output
  end

  private

  def guides_for_output
    guides = self.guides.map do |g|
      guide = g.published_version
      next unless guide.present?
      {
        title: guide.content_item.title,
        url_path: guide.content_item.url_path
      }
    end
    guides.compact
  end
end
