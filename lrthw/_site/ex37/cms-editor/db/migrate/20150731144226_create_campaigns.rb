class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :subtype
      t.string :status
      t.string :featured_image
      t.string :featured_image_alt
      t.date :start
      t.date :end
      t.text :supporting_information
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone

      t.timestamps null: false
    end
  end
end
