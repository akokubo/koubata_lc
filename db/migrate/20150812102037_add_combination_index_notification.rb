class AddCombinationIndexNotification < ActiveRecord::Migration
  def change
    add_index :notifications, :url
    add_index :notifications, [:user_id, :url], unique: true
  end
end
