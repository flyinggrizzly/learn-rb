class AddUsernameField < ActiveRecord::Migration
  def change
    change_table :content_items do |t|
      t.string :created_by
      t.string :updated_by
    end
  end
end
