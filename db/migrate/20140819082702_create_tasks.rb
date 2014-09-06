class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string     :type,        null: false
      t.references :user,        index: true
      t.string     :title,       null: false
      t.references :category,    index: true
      t.text       :description
      t.string     :price,       null:false
      t.datetime   :expired_at

      t.timestamps
    end
  end
end
