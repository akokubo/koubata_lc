class AddIndexToMessages < ActiveRecord::Migration
  def change
    add_index :messages, :sender_id
    add_index :messages, :recepient_id
  end
end
