class UpdateCtaServiceStarts < ActiveRecord::Migration
  def up
    add_column :service_starts, :call_to_action_type, :string
    add_column :service_starts, :call_to_action_reason, :string
    rename_column :service_starts, :call_to_action_url, :call_to_action_content

    execute "UPDATE service_starts SET call_to_action_type = 'url'"
  end

  def down
    remove_column :service_starts, :call_to_action_type
    remove_column :service_starts, :call_to_action_reason
    rename_column :service_starts, :call_to_action_content, :call_to_action_url
  end
end