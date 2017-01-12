class UpdateContactDetailsPublications < ActiveRecord::Migration
  def up
    add_column :publications, :contact_name, :string
    add_column :publications, :contact_email, :string
    add_column :publications, :contact_phone, :string
  end

  def down
    remove_column :publications, :contact_name
    remove_column :publications, :contact_email
    remove_column :publications, :contact_phone
  end
end
