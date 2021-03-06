class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :body
      t.string :url, default: '#'
      t.datetime :read_at

      t.timestamps null: false
    end
  end
end
