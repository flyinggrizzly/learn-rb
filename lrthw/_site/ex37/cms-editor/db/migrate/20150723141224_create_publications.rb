class CreatePublications < ActiveRecord::Migration
  def change
    create_table :publications do |t|
      t.string :subtype
      t.integer :last_published_version

      t.timestamps null: false
    end
  end
end
