class CreatePassings < ActiveRecord::Migration
  def change
    create_table :passings do |t|
      t.references :message,      index: true
      t.references :user,         index: true
      t.integer    :companion_id, null: false
      t.string     :direction,    null: false
    end
  end
end
