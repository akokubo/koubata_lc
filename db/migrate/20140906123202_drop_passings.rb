class DropPassings < ActiveRecord::Migration
  def change
    drop_table :passings
  end
end
