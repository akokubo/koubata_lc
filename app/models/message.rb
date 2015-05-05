class Message < ActiveRecord::Base
  belongs_to :sender,    class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recepient, class_name: 'User', foreign_key: 'recepient_id'

  # 必須属性の検証
  validates :subject,      presence: true
  validates :body,         presence: true
  validates :sender_id,    presence: true
  validates :recepient_id, presence: true
end
