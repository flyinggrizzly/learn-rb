class CreateContentItems < ActiveRecord::Migration
  def change
    create_table :content_items do |t|
      t.string :as_a
      t.string :i_need
      t.string :so_that
      t.string :title
      t.string :summary
      t.string :body_content

      t.timestamps null: false
    end
  end
end
