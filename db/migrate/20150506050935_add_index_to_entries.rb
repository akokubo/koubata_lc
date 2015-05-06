class AddIndexToEntries < ActiveRecord::Migration
  def change
    add_index :entries, [:task_id, :user_id], unique: true
  end
end
