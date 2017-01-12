class CreatePublicationAttachments < ActiveRecord::Migration
  def change
    create_table :publication_attachments do |t|
      t.string :title
      t.string :attachment_filename
      t.belongs_to :publication, index: true

      t.timestamps null: false
    end
    add_foreign_key :publication_attachments, :publications
  end
end
