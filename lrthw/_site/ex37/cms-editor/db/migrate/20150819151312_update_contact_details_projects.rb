class UpdateContactDetailsProjects < ActiveRecord::Migration
  def up
    remove_column :projects, :enquiries
    add_column :projects, :contact_name, :string
    add_column :projects, :contact_email, :string
    add_column :projects, :contact_phone, :string
  end

  def down
    remove_column :projects, :contact_name
    remove_column :projects, :contact_email
    remove_column :projects, :contact_phone
    add_column :projects, :enquiries, :string
  end
end
