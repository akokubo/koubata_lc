class ModifyPayments < ActiveRecord::Migration
  def change
    rename_column :payments, :user_id,    :sender_id
    rename_column :payments, :partner_id, :recepient_id
    rename_column :payments, :balance,                  :sender_balance_after
    add_column    :payments, :sender_balance_before,    :integer
    add_column    :payments, :recepient_balance_before, :integer
    add_column    :payments, :recepient_balance_after,  :integer
    remove_column :payments, :direction
  end
end
