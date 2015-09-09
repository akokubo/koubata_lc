class RenameColumnPayments < ActiveRecord::Migration
  def change
    rename_column :payments, :sender_id, :sender_account_id
    rename_column :payments, :recepient_id, :recepient_account_id
  end
end
