class PriceToDecimalInEvent < ActiveRecord::Migration
  def up
    remove_column :events, :price
    add_column :events, :price, :decimal, precision: 7, scale: 2
  end

  def down
    remove_column :events, :price
    add_column :events, :price, :float
  end
end
