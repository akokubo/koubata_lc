class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :subject, null: false
      t.text   :body,    null: false

      t.timestamps
    end
  end
end
