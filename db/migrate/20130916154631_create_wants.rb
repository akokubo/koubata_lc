class CreateWants < ActiveRecord::Migration
  def change
    create_table :wants do |t|
      t.references :user, index: true
      t.string :title
      t.text :description
      t.datetime :expired_at

      t.timestamps
    end
  end
end
