class CreateOrganisationLandingPages < ActiveRecord::Migration
  def change
    create_table :organisation_landing_pages do |t|
      t.text :about
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.string :on_off_campus
      t.string :building
      t.string :room
      t.string :address_1
      t.string :address_2
      t.string :town
      t.string :postcode
      t.string :country
      t.string :featured_item_1
      t.string :featured_item_2
      t.string :featured_item_3
      t.string :featured_item_4
      t.string :featured_item_5
      t.string :featured_item_6
      t.integer :last_published_version

      t.timestamps null: false
    end
  end
end
