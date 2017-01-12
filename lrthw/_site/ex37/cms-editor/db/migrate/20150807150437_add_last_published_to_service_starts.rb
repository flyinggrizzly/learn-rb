class AddLastPublishedToServiceStarts < ActiveRecord::Migration
  def change
    change_table :service_starts do |t|
      t.integer :last_published_version
    end
  end
end
