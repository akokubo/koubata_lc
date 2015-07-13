class AddEntryIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :entry_id, :integer
  end
end
