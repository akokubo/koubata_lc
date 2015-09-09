class RenameColumnTasks < ActiveRecord::Migration
  def change
    rename_column :tasks, :price, :price_description
    rename_column :entries, :prior_price, :prior_price_description

    remove_column :tasks, :closed_at
    remove_column :entries, :closed_at

    remove_column :tasks, :expired_at
    remove_column :entries, :expired_at

    add_column :tasks, :opened, :boolean, default: true
    add_column :entries, :opened, :boolean, default: true
  end
end
