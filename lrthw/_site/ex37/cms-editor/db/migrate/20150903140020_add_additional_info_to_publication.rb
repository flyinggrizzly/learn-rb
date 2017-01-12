class AddAdditionalInfoToPublication < ActiveRecord::Migration
  def change
    add_column :publications, :additional_info, :text
  end
end
