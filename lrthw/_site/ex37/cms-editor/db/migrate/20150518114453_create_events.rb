class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :subtype
      t.datetime :start
      t.datetime :end
      t.string :location
      t.string :building
      t.string :town
      t.string :postcode
      t.string :country
      t.text :accessibility
      t.string :audience
      t.string :audience_detail
      t.text :description
      t.text :speaker_profile
      t.string :booking_method
      t.string :booking_email
      t.string :booking_link
      t.boolean :charge
      t.float :price
      t.string :featured_image
      t.string :featured_image_caption
      t.string :featured_image_alt
      t.string :hashtag
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone

      t.timestamps null: false
    end
  end

  def down
    drop_table :events
  end
end
