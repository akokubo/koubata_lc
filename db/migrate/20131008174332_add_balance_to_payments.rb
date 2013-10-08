class AddBalanceToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :balance, :integer
  end
end
