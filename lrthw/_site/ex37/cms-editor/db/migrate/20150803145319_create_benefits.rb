class CreateBenefits < ActiveRecord::Migration
  def change
    create_table :benefits do |t|
      t.text :description
      t.string :call_to_action_label
      t.string :call_to_action_url
      t.string :image
      t.string :image_alt
      t.string :image_caption
      t.string :object_title
      t.text :object_embed_code
      t.belongs_to :campaign, index: true

      t.timestamps null: false
    end
    add_foreign_key :benefits, :campaigns
  end
end
