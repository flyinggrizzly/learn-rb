class UpdatePersonProfile < ActiveRecord::Migration
  def up
    remove_column :person_profiles, :academic_post_nominal_letters
    remove_column :person_profiles, :courses_taught
    add_column :person_profiles, :courses_taught_undergrad, :text
    add_column :person_profiles, :courses_taught_postgrad, :text
  end

  def down
    remove_column :person_profiles, :courses_taught_undergrad
    remove_column :person_profiles, :courses_taught_postgrad
    add_column :person_profiles, :academic_post_nominal_letters, :string
    add_column :person_profiles, :courses_taught, :text
  end
end
