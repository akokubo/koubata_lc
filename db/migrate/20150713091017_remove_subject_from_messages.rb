class RemoveSubjectFromMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :subject
  end
end
