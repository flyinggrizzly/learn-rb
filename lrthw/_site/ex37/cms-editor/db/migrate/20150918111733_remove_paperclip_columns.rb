class RemovePaperclipColumns < ActiveRecord::Migration
  def up
    change_table :content_attachments do |t|
      t.remove :attachment_file_name, :attachment_content_type, :attachment_file_size, :attachment_updated_at
    end
  end
  def down
    change_table :content_attachments do |t|
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.integer :attachment_file_size
      t.date :attachment_updated_at
    end
  end
end
