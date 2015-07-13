class RemoveIndexFromEntries < ActiveRecord::Migration
  def change
    remove_index :entries, [:task_id, :user_id]
  end
end
