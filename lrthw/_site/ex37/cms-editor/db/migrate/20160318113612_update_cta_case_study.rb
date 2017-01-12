class UpdateCtaCaseStudy < ActiveRecord::Migration
  def up
    add_column :case_studies, :call_to_action_type, :string
    add_column :case_studies, :call_to_action_reason, :string
    rename_column :case_studies, :call_to_action_url, :call_to_action_content

    execute "UPDATE case_studies SET call_to_action_type = 'url'"
  end

  def down
    remove_column :case_studies, :call_to_action_type
    remove_column :case_studies, :call_to_action_reason
    rename_column :case_studies, :call_to_action_content, :call_to_action_url
  end
end
