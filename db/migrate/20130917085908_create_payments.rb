class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :from, index: true
      t.references :to, index: true
      t.string :subject
      t.integer :amount
      t.text :comment

      t.timestamps
    end
  end
end
