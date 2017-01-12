class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.string :name
      t.string :contact_information

      t.timestamps null: false
    end
  end
end
