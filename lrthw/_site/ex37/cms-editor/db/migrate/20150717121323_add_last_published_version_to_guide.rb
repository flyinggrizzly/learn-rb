class AddLastPublishedVersionToGuide < ActiveRecord::Migration
  def up
    add_column :guides, :last_published_version, :integer
  end

  def down
    remove_column :guides, :last_published_version
  end
end
