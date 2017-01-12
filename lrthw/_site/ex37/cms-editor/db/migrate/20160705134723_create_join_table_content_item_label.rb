# This was generated by running: rails g migration CreateJoinTableContentItemLabel content_item label
class CreateJoinTableContentItemLabel < ActiveRecord::Migration
  def change
    create_join_table :content_items, :labels do |t|
      t.index [:content_item_id, :label_id]
      t.index [:label_id, :content_item_id]
    end
  end
end
