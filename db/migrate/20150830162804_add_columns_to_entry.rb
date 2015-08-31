class AddColumnsToEntry < ActiveRecord::Migration
  def change
    add_reference :entries, :category, index: true, foreign_key: true
    add_column :entries, :closed_at, :datetime
    add_column :entries, :description, :text
    add_column :entries, :expired_at, :datetime
    add_column :entries, :prior_price, :string
    add_column :entries, :title, :string
    add_column :entries, :owner_id, :integer, index: true
    rename_column :entries, :user_id, :contractor_id
    rename_column :entries, :user_committed_at, :contractor_committed_at
    rename_column :entries, :user_canceled_at, :contractor_canceled_at
    remove_column :entries, :task_id
    remove_column :entries, :note
    remove_column :entries, :type
  end
end
