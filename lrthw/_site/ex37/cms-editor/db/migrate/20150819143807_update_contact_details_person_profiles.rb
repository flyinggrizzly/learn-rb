class UpdateContactDetailsPersonProfiles < ActiveRecord::Migration
  def up
    remove_column :person_profiles, :contact_details
    add_column :person_profiles, :contact_name, :string
    add_column :person_profiles, :contact_email, :string
    add_column :person_profiles, :contact_phone, :string
  end

  def down
    remove_column :person_profiles, :contact_name
    remove_column :person_profiles, :contact_email
    remove_column :person_profiles, :contact_phone
    add_column :person_profiles, :contact_details, :text
  end
end
