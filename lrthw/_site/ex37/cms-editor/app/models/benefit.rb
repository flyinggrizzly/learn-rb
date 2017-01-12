# Benefit object, used in Campaigns
class Benefit < ActiveRecord::Base
  include CanHaveCallToAction
  include CanStripCarriageReturns

  belongs_to :campaign
  has_paper_trail

  # Validate presence
  validates :description, presence: true

  # Validate length
  validates :object_title,
            length: { maximum: 160 }
  validates :image, :image_alt, :image_caption,
            length: { maximum: 255 }
  validates :description, :object_embed_code,
            length: { maximum: 1_000 }

  # Validate as url if present
  validates :image, url: true, allow_blank: true

  # Ensure there is an image_alt and image_caption if there is a image
  validates :image_alt, :image_caption, presence: { if: :image? }

  # Ensure there is an object_title if there is an object_embed_code and vice versa
  validates :object_title, presence: { if: :object_embed_code? }
  validates :object_embed_code, presence: { if: :object_title? }

  default_scope { order('id ASC') }
end
