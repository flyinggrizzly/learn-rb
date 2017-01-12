class Url < ActiveRecord::Base
  belongs_to :person_profile
  has_paper_trail

  # validate length
  validates :url, length: { maximum: 255 }

  # validate as url if present
  validates :url, url: true, allow_blank: true

  default_scope { order('id DESC') }
end
