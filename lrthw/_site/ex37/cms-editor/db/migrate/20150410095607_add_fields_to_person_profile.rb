class AddFieldsToPersonProfile < ActiveRecord::Migration
  def change
    add_column :person_profiles, :academic_post_nominal_letters, :string
    add_column :person_profiles, :role_holder_photo_url, :string
    add_column :person_profiles, :role_holder_photo_alt_text, :string
    add_column :person_profiles, :role_holder_photo_caption, :string
    add_column :person_profiles, :role_related_posts_held, :string
    add_column :person_profiles, :separate_with_commas, :string
    add_column :person_profiles, :achievements_in_role, :text
    add_column :person_profiles, :career_achievements, :text
    add_column :person_profiles, :professional_associations, :text
    add_column :person_profiles, :education, :text
    add_column :person_profiles, :community_associations, :text
    add_column :person_profiles, :all_publications_url, :string
    add_column :person_profiles, :supervisor_availability, :integer
    add_column :person_profiles, :supporting_external_url, :string
  end
end
