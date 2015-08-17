class AddPaymentToEntries < ActiveRecord::Migration
  def change
    add_reference :entries, :payment, index: true, foreign_key: true
  end
end
