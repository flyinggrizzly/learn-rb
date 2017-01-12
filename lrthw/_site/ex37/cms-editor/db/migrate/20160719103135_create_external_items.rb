class CreateExternalItems < ActiveRecord::Migration
  def change
    create_table :external_items do |t|
      t.string :subtype
      t.string :external_url
      t.string :featured_image
      t.string :featured_image_alt
      t.string :featured_image_caption
      t.integer :last_published_version

      t.timestamps null: false
    end
  end
end
