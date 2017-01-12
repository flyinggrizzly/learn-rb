class AddFields < ActiveRecord::Migration
  def change
    add_column :person_profiles, :courses_taught, :text
    add_column :person_profiles, :research_interests, :text
    add_column :person_profiles, :current_research_projects, :text
  end
end
