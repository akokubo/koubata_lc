class AddDirectionToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :direction, :string
    rename_column :payments, :from_id, :user_id
    rename_column :payments, :to_id, :partner_id
  end
end
