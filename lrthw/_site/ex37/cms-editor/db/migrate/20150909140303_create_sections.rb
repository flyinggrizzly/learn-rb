class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.string :title
      t.text :body_content
      t.belongs_to :guide, index: true
      t.timestamps null: false
    end
    add_foreign_key :sections, :guides
  end
end
