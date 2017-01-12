class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :display_name
      t.string :first_name
      t.string :last_name
      t.integer :person_id

      t.timestamps null: false
    end

    add_index :users, :username, unique: true
  end
end
