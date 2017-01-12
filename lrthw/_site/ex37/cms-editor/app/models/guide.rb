# Model for Guide content type
class Guide < ActiveRecord::Base
  include CanHaveCallToAction
  include CanHaveContact
  include CanHaveFeaturedImage
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_many :sections, dependent: :destroy
  has_and_belongs_to_many :service_starts
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true
  accepts_nested_attributes_for :sections, allow_destroy: true, reject_if: :all_blank

  # validates presence
  validates :subtype, presence: true

  # Validate presence and must be one of list
  validates :subtype, inclusion: { in: %w(basic_guide detailed_guide) }

  # validate length
  validates :object_title,
            length: { maximum: 160 }
  validates :object_embed_code,
            length: { maximum: 1_000 }
  # validate that we have at least one section for basic guide
  validates :sections,
            length: { minimum: 1, message: :basic_guide_no_section }, if: proc { |g| g.subtype == 'basic_guide' }
  # Validate that we have no more than 1 section for a basic guide - because the form has two sections to fill in
  # for people to switch to detailed guide
  validates :sections,
            length: { maximum: 1, message: :sections_too_many }, if: proc { |g| g.subtype == 'basic_guide' }
  # Validate that we have at least 2 sections for a detailed guide
  validates :sections,
            length: { minimum: 2, message: :sections_too_few }, if: proc { |g| g.subtype == 'detailed_guide' }

  def output_attributes
    output = attributes
    output[:sections] = sections(&:section)
    output
  end

  # Used in forms where Guides are an associated content type
  def display_title
    content_item.title
  end
end
