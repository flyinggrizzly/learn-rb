class AddPublishedItemJsonToContentItem < ActiveRecord::Migration
  def change
    add_column :content_items, :published_item_json, :text

    # Add a constraint to ensure JSON data is well-formed
    # See https://docs.oracle.com/database/121/ADXDB/json.htm
    reversible do |constraint|
      constraint.up do
        execute 'ALTER TABLE content_items ADD CONSTRAINT ensure_json CHECK (published_item_json IS JSON)'
      end
      constraint.down do
        execute 'ALTER TABLE content_items DROP CONSTRAINT ensure_json'
      end
    end
  end
end
