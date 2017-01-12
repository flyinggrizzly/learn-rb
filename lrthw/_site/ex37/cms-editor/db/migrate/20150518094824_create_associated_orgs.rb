class CreateAssociatedOrgs < ActiveRecord::Migration
  def change
    create_table :associated_orgs do |t|
      t.string :name
      t.string :contact_information

      t.timestamps null: false
    end
  end
end
