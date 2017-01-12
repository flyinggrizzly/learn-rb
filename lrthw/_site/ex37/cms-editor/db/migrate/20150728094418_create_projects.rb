class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :subtype
      t.string :status
      t.text :project_overview
      t.string :budget
      t.date :start
      t.date :end
      t.string :enquiries
      t.string :featured_image
      t.string :featured_image_alt
      t.string :featured_image_caption
      t.string :object_title
      t.text :object_embed_code

      t.timestamps null: false
    end
  end
end
