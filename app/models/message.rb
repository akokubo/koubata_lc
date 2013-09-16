class Message < ActiveRecord::Base
  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  # 必須属性の検証
  validates :from_id, presence: true
  validates :to_id, presence: true
  validates :subject, presence: true
  validates :body, presence: true
end
