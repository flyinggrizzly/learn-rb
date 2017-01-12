class CreateCaseStudies < ActiveRecord::Migration
  def change
    create_table :case_studies do |t|
      t.string :subtype
      t.string :subject
      t.text :body_content
      t.string :quote
      t.string :quote_attribution
      t.string :featured_image
      t.string :featured_image_alt
      t.string :featured_image_caption
      t.string :object_title
      t.text :object_embed_code
      t.string :call_to_action_label
      t.string :call_to_action_url
      t.integer :last_published_version

      t.timestamps null: false
    end
  end
end
