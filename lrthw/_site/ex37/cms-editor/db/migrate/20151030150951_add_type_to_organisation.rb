class AddTypeToOrganisation < ActiveRecord::Migration
  def change
    add_column :organisations, :type, :string
  end
end
