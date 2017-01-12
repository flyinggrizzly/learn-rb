class AddLastPublishedToProjects < ActiveRecord::Migration
  def change
    change_table :projects do |t|
      t.integer :last_published_version
    end
  end
end
