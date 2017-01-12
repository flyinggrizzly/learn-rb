class UpdateCtaBenefit < ActiveRecord::Migration
  def up
    add_column :benefits, :call_to_action_type, :string
    add_column :benefits, :call_to_action_reason, :string
    rename_column :benefits, :call_to_action_url, :call_to_action_content

    execute "UPDATE benefits SET call_to_action_type = 'url'"
  end

  def down
    remove_column :benefits, :call_to_action_type
    remove_column :benefits, :call_to_action_reason
    rename_column :benefits, :call_to_action_content, :call_to_action_url
  end
end
