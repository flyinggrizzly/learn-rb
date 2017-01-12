class CreateServiceStarts < ActiveRecord::Migration
  def change
    create_table :service_starts do |t|
      t.text :usage_instructions
      t.string :call_to_action_label
      t.string :call_to_action_url
      t.string :contact_details

      t.timestamps null: false
    end
  end
end
