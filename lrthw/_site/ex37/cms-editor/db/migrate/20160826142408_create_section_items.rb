class CreateSectionItems < ActiveRecord::Migration
  def change
    create_table :section_items do |t|
      t.integer :item_order
      t.belongs_to :collection_section, index: true
      t.belongs_to :content_item, index: true

      t.timestamps null: false
    end
    add_foreign_key :section_items, :collection_sections
    add_foreign_key :section_items, :content_items
  end
end
