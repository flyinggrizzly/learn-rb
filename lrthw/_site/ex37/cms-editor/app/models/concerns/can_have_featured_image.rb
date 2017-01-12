# Validations for featured image fields
module CanHaveFeaturedImage
  extend ActiveSupport::Concern

  included do
    # General lengths
    validates :featured_image, :featured_image_alt, :featured_image_caption,
              length: { maximum: 255 }

    # Validate as url if present
    validates :featured_image, url: true, allow_blank: true

    # Ensure there is a featured_image_alt and featured_image_caption if there is a featured_image
    validates :featured_image_alt, :featured_image_caption, presence: { if: :featured_image? }
  end
end
