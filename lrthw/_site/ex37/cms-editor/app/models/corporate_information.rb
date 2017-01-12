class CorporateInformation < ActiveRecord::Base
  include CanHaveCallToAction
  include CanStripCarriageReturns
  include CanHaveFeaturedImage
  include CanConstructUrl
  # The CanHavePublishingMetadataHooks concern should always be included last so the callbacks in there run last
  include CanHavePublishingMetadataHooks

  has_one :content_item, as: :core_data, dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :content_item, allow_destroy: true

  # validate presence
  validates :body_content, presence: true

  # validate presence and must be one of list
  validates :subtype, inclusion: { in: %w(code_of_practice
                                          factsheet
                                          letter
                                          policy
                                          procedure
                                          regulation
                                          speech
                                          strategy
                                          timetable) }

  # validate length
  validates :object_title,
            length: { maximum: 160 }
  validates :object_embed_code,
            length: { maximum: 1_000 }
  validates :body_content,
            length: { maximum: 50_000 }

  # ensure there is a object_title if there is an object_embed_code and vice versa
  validates :object_title, presence: { if: :object_embed_code? }
  validates :object_embed_code, presence: { if: :object_title? }

  def output_attributes
    attributes
  end
end
