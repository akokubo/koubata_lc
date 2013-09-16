class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :from, index: true
      t.references :to, index: true
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
