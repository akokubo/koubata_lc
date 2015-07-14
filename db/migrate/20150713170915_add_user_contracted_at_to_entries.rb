class AddUserContractedAtToEntries < ActiveRecord::Migration
  def change
    rename_column :entries, :contracted_at, :owner_contracted_at
    add_column :entries, :user_contracted_at, :datetime
  end
end
