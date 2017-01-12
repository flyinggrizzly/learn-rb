class UpdateContactDetailsGuides < ActiveRecord::Migration
  def up
    remove_column :guides, :contact_details
    add_column :guides, :contact_name, :string
    add_column :guides, :contact_email, :string
    add_column :guides, :contact_phone, :string
  end

  def down
    remove_column :guides, :contact_name
    remove_column :guides, :contact_email
    remove_column :guides, :contact_phone
    add_column :guides, :contact_details, :string
  end
end
