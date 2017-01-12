class AddContentItemsToOrganisations < ActiveRecord::Migration
  def change
    change_table :content_items do |t|
      t.belongs_to :organisation, index: true
    end
  end
end
