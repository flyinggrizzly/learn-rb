class AddStatusToContentItem < ActiveRecord::Migration
  def change
    add_column :content_items, :status, :integer, default: 0
  end
end
