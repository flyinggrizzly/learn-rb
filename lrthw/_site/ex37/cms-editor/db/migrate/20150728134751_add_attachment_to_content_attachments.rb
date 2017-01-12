class AddAttachmentToContentAttachments < ActiveRecord::Migration
  def change
    change_table :content_attachments do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.date :attachment_updated_at
    end
  end
end
