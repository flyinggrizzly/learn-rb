class CollectionSection < ActiveRecord::Base
  belongs_to :collection

  has_many :content_items, through: :section_items
  has_many :section_items, dependent: :destroy
  has_paper_trail

  accepts_nested_attributes_for :section_items, allow_destroy: true, reject_if: :reject_section_items

  # Validate presence
  validates :title, :summary, presence: true

  # Validate length
  validates :title,
            length: { maximum: 65 }
  validates :summary,
            length: { maximum: 255 }

  # Validate that we have at least one content item for a section
  validates :section_items,
            association_count: { minimum: 1, message: :collection_section_no_items }

  default_scope { order("#{table_name}.id ASC") }

  def reject_section_items(attributes)
    # Will have an id if already exists
    exists = attributes['id'].present?
    # Consider invalid if no content_item_id field
    empty = attributes['content_item_id'].blank?
    # Add the destroy attribute if exists and is empty
    attributes[:_destroy] = 1 if exists && empty
    # Return for reject_if
    (!exists && empty)
  end
end
