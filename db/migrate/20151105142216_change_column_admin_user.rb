class ChangeColumnAdminUser < ActiveRecord::Migration
  def self.up
    change_column_default :users, :admin, false
  end
  def self.down
    change_column_default :users, :admin, nil
  end
end
