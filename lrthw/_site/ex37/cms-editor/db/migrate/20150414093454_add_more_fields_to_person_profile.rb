class AddMoreFieldsToPersonProfile < ActiveRecord::Migration
  def change
    add_column :person_profiles, :contact_details, :string
    add_column :person_profiles, :person_finder_link, :string
    add_column :person_profiles, :subtype, :string
  end
end
