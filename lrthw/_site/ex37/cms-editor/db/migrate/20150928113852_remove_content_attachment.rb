class RemoveContentAttachment < ActiveRecord::Migration
  def up
    drop_table :content_attachments
  end

  def down
    create_table :content_attachments do |t|
      t.belongs_to :content_item, index: true
      t.timestamps null: false
    end
  end
end
