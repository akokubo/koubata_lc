class ChangeEntries < ActiveRecord::Migration
  def change
    add_column :entries, :type, :string
    rename_column :entries, :hired_at, :contracted_at
    add_column :entries, :expected_at, :datetime
    add_column :entries, :performed_at, :datetime
    add_column :entries, :owner_canceled_at, :datetime
    add_column :entries, :user_canceled_at, :datetime
    add_column :entries, :note, :text
  end
end
