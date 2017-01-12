class CreateHighlightedItems < ActiveRecord::Migration
  def change
    create_table :highlighted_items do |t|
      t.string :item
      t.string :item_type
      t.integer :item_order
      t.integer :olp_announcement_id
      t.integer :olp_campaign_id
      t.integer :olp_case_study_id
      t.integer :olp_corporate_information_id
      t.integer :olp_event_id
      t.integer :olp_guide_id
      t.integer :olp_location_id
      t.integer :olp_person_profile_id
      t.integer :olp_project_id
      t.integer :olp_publication_id
      t.integer :olp_service_start_id
      t.integer :olp_team_profile_id

      t.timestamps null: false
    end
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_announcement_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_campaign_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_case_study_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_corporate_information_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_event_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_guide_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_location_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_person_profile_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_project_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_publication_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_service_start_id
    add_foreign_key :highlighted_items, :organisation_landing_pages, column: :olp_team_profile_id
  end
end
