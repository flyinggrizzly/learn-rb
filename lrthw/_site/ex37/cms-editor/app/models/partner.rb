# Partner object, used in Project
class Partner < ActiveRecord::Base
  belongs_to :project
  belongs_to :campaign
  has_paper_trail

  # validate presence
  validates :name, presence: true

  # validate length
  validates :name,
            length: { maximum: 160 }
  validates :logo_url, :logo_alt, :link_url, :link_text,
            length: { maximum: 255 }

  # ensure there is a logo_url if there is an logo_alt and vice versa
  validates :logo_alt, presence: { if: :logo_url? }
  validates :logo_url, presence: { if: :logo_alt? }

  # ensure there is a link_url if there is an link_text and vice versa
  validates :link_text, presence: { if: :link_url? }
  validates :link_url, presence: { if: :link_text? }

  # validate as url if present
  validates :link_url, :logo_url, url: true, allow_blank: true

  default_scope { order('id ASC') }
end
