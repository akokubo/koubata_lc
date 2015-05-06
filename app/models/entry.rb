class Entry < ActiveRecord::Base
  belongs_to :task
  belongs_to :user

  # 必須属性の検証
  validates :task_id, presence: true
  validates :user_id, presence: true
end
