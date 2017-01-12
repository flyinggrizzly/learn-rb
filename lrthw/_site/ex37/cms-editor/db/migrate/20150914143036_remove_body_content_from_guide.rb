class RemoveBodyContentFromGuide < ActiveRecord::Migration
  def up
    change_table :guides do |t|
      t.remove :body_content
    end
  end

  def down
    change_table :guides do |t|
      t.text :body_content
    end
  end
end
