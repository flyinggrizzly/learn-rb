class ExternalItem < ActiveRecord::Base
  include CanHaveFeaturedImage
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true

  # Validate presence
  validates :subtype, :external_url, presence: true

  # Validate presence and must be one of list
  validates :subtype, inclusion: { in: %w(university external) }

  # Validate length
  validates :external_url,
            length: { maximum: 255 }

  # Validate as url
  validates :external_url, url: true

  # Validate external_url matches subtype
  validates :external_url, format: { with: %r{https?://[^.]+\.bath\.ac\.uk.*}, message: :not_a_uob_page },
                           if: proc { |item| item.subtype == 'university' }
  validates :external_url, format: { without: %r{https?://[^.]+\.bath\.ac\.uk.*}, message: :not_an_external_page },
                           if: proc { |item| item.subtype == 'external' }

  # Validate uob page is not content publisher page
  validates :external_url, non_content_publisher_url: true, if: proc { |item| item.subtype == 'university' }

  def output_attributes
    attributes
  end
end
