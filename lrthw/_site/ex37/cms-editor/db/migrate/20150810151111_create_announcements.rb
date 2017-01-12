class CreateAnnouncements < ActiveRecord::Migration
  def change
    create_table :announcements do |t|
      t.string :subtype
      t.text :body_content
      t.string :featured_image
      t.string :featured_image_alt
      t.string :featured_image_caption
      t.string :object_title
      t.text :object_embed_code
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.string :call_to_action_label
      t.string :call_to_action_url
      t.integer :last_published_version

      t.timestamps null: false
    end
  end
end
