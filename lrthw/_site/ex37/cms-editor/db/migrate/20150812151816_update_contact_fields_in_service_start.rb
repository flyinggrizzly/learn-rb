class UpdateContactFieldsInServiceStart < ActiveRecord::Migration
  def up
    remove_column :service_starts, :contact_details
    add_column :service_starts, :contact_name, :string
    add_column :service_starts, :contact_email, :string
    add_column :service_starts, :contact_phone, :string
  end

  def down
    remove_column :service_starts, :contact_name
    remove_column :service_starts, :contact_email
    remove_column :service_starts, :contact_phone
    add_column :service_starts, :contact_details, :string
  end
end
