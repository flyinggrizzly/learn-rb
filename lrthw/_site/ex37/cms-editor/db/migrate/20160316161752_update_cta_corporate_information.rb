class UpdateCtaCorporateInformation < ActiveRecord::Migration
  def up
    add_column :corporate_informations, :call_to_action_type, :string
    add_column :corporate_informations, :call_to_action_reason, :string
    rename_column :corporate_informations, :call_to_action_url, :call_to_action_content

    execute "UPDATE corporate_informations SET call_to_action_type = 'url'"
  end

  def down
    remove_column :corporate_informations, :call_to_action_type
    remove_column :corporate_informations, :call_to_action_reason
    rename_column :corporate_informations, :call_to_action_content, :call_to_action_url
  end
end
