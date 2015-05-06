class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.references :task, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :hired_at
      t.datetime :paid_at

      t.timestamps null: false
    end
  end
end
