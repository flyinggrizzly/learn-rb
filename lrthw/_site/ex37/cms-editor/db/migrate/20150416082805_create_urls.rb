class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string :url
      t.belongs_to :person_profile, index: true

      t.timestamps null: false
    end
    add_foreign_key :urls, :person_profiles
  end
end
