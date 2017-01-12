class CreatePartners < ActiveRecord::Migration
  def change
    create_table :partners do |t|
      t.string :name
      t.string :logo_url
      t.string :logo_alt
      t.string :link_url
      t.string :link_text
      t.belongs_to :project, index: true

      t.timestamps null: false
    end
    add_foreign_key :partners, :projects
  end
end
