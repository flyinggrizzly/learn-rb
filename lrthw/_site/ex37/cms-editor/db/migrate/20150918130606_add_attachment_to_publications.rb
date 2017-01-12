class AddAttachmentToPublications < ActiveRecord::Migration
  def change
    change_table :publications do |t|
      t.string :attachment_filename
    end
  end
end
