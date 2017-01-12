class UpdateCtaAnnouncement < ActiveRecord::Migration
  def up
    add_column :announcements, :call_to_action_type, :string
    add_column :announcements, :call_to_action_reason, :string
    rename_column :announcements, :call_to_action_url, :call_to_action_content

    execute "UPDATE announcements SET call_to_action_type = 'url'"
  end

  def down
    remove_column :announcements, :call_to_action_type
    remove_column :announcements, :call_to_action_reason
    rename_column :announcements, :call_to_action_content, :call_to_action_url
  end
end
