class AddSenderIdAndRecepientIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :sender_id,    :integer, null: false, default: ""
    add_column :messages, :recepient_id, :integer, null: false, default: ""
  end
end
