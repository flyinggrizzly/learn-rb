class AddUrlPathToContentItem < ActiveRecord::Migration
  def up
    add_column :content_items, :url_path, :string
  end

  def down
    remove_column :content_items, :url_path
  end
end
