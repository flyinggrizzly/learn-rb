class UpdateContentItem < ActiveRecord::Migration
  def change
    add_index :content_items, :core_data_id
  end
end
