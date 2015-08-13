class RenameColumnForEntries < ActiveRecord::Migration
  def change
    rename_column :entries, :owner_contracted_at, :owner_committed_at
    rename_column :entries, :user_contracted_at,  :user_committed_at
  end
end
