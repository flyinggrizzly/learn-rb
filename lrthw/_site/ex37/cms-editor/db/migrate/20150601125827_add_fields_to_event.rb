class AddFieldsToEvent < ActiveRecord::Migration
  def up
    remove_column :events, :location

    add_column :events, :location, :string
    add_column :events, :venue, :string
    add_column :events, :address_1, :string
    add_column :events, :address_2, :string
    add_column :events, :room_number, :string
  end

  def down
    remove_column :events, :location
    remove_column :events, :venue
    remove_column :events, :address_1
    remove_column :events, :address_2
    remove_column :events, :room_number

    add_column :events, :location, :string
  end
end
