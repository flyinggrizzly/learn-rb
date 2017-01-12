class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :subtype
      t.string :on_off_campus
      t.string :building
      t.string :room
      t.string :address_1
      t.string :address_2
      t.string :town
      t.string :postcode
      t.string :country
      t.string :longitude
      t.string :latitude
      t.text :accessibility
      t.text :additional_information
      t.string :featured_image
      t.string :featured_image_alt
      t.string :featured_image_caption
      t.text :map_embed_code
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.string :opening_time_monday
      t.string :opening_time_tuesday
      t.string :opening_time_wednesday
      t.string :opening_time_thursday
      t.string :opening_time_friday
      t.string :opening_time_saturday
      t.string :opening_time_sunday
      t.text :opening_time_notes
      t.integer :last_published_version

      t.timestamps null: false
    end
  end
end
