class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.timestamps null: false
      t.integer :last_published_version
    end
  end
end
