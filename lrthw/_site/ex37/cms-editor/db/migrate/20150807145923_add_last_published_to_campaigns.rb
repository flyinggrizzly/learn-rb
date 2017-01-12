class AddLastPublishedToCampaigns < ActiveRecord::Migration
  def change
    change_table :campaigns do |t|
      t.integer :last_published_version
    end
  end
end
