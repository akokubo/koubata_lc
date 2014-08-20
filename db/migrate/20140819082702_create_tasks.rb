class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :type, null: false
      t.references :user, index: true
      t.string :title
      t.references :category
      t.text :description
      t.string :price
      t.datetime :expired_at

      t.timestamps
    end
  end
end
