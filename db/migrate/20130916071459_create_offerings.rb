class CreateOfferings < ActiveRecord::Migration
  def change
    create_table :offerings do |t|
      t.references :user, index: true
      t.string :title
      t.references :category, index: true
      t.text :description
      t.string :price
      t.datetime :expired_at

      t.timestamps
    end
  end
end
