class AddContactDetailsToCaseStudies < ActiveRecord::Migration
  def up
    add_column :case_studies, :contact_name, :string
    add_column :case_studies, :contact_email, :string
    add_column :case_studies, :contact_phone, :string
  end

  def down
    remove_column :case_studies, :contact_name
    remove_column :case_studies, :contact_email
    remove_column :case_studies, :contact_phone
  end
end
