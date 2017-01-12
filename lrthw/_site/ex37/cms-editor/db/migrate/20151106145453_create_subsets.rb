class CreateSubsets < ActiveRecord::Migration
  def change
    create_table :subsets do |t|
      t.string :title
      t.text :membership
      t.belongs_to :team_profile, index: true
      t.timestamps null: false
    end
    add_foreign_key :subsets, :team_profiles
  end
end
