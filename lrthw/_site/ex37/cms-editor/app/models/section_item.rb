class SectionItem < ActiveRecord::Base
  belongs_to :collection_section
  belongs_to :content_item

  has_paper_trail

  default_scope { order('item_order ASC') }
end
