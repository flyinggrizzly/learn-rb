class Label < ActiveRecord::Base
  has_and_belongs_to_many :content_items
  has_paper_trail

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :name, length: { maximum: 65 }
  validates :description, length: { maximum: 255 }
end
