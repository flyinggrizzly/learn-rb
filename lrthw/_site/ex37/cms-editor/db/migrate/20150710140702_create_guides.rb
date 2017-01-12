class CreateGuides < ActiveRecord::Migration
  def change
    create_table :guides do |t|
      t.string :subtype
      t.text :body_content
      t.string :call_to_action_label
      t.string :call_to_action_url
      t.string :contact_details
      t.string :featured_image
      t.string :featured_image_alt
      t.string :featured_image_caption
      t.string :object_title
      t.text :object_embed_code

      t.timestamps null: false
    end
  end
end
