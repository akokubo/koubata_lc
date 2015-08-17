class AddPriceToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :price, :integer, default: 0
  end
end
