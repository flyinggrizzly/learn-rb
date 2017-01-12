class CreateCollectionSections < ActiveRecord::Migration
  def change
    create_table :collection_sections do |t|
      t.string :title
      t.text :summary
      t.belongs_to :collection, index: true

      t.timestamps null: false
    end
    add_foreign_key :collection_sections, :collections
  end
end
