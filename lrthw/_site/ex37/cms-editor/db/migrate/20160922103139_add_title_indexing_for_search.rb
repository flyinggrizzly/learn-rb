class AddTitleIndexingForSearch < ActiveRecord::Migration
  def up
    add_context_index :content_items, :title, sync: 'ON COMMIT'
  end

  def down
    remove_context_index :content_items, :title
  end
end
