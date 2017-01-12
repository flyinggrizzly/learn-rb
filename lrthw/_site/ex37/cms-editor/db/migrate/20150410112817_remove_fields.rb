class RemoveFields < ActiveRecord::Migration
  def change
    remove_column :content_items, :body_content
    remove_column :person_profiles, :separate_with_commas
  end
end
