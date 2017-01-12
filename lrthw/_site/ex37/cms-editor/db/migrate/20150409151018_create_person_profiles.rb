class CreatePersonProfiles < ActiveRecord::Migration
  def change
    create_table :person_profiles do |t|
      t.string :role_holder_name
      t.string :honours_post_nominal_letters

      t.timestamps null: false
    end
    add_reference :content_items, :core_data, polymorphic: true, index: true
  end
end
