class CreateContentAttachments < ActiveRecord::Migration
  def change
    create_table :content_attachments do |t|
      t.belongs_to :content_item, index: true
      t.timestamps null: false
    end
  end
end
