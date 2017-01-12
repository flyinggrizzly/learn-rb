class UpdatePersonProfileColumns < ActiveRecord::Migration
  def up
    remove_column :person_profiles, :contact_details
    remove_column :person_profiles, :role_related_posts_held
    add_column :person_profiles, :contact_details, :text
    add_column :person_profiles, :role_related_posts_held, :text
  end

  def down
    remove_column :person_profiles, :contact_details
    remove_column :person_profiles, :role_related_posts_held
    add_column :person_profiles, :contact_details, :string
    add_column :person_profiles, :role_related_posts_held, :string
  end
end
