class Message < ActiveRecord::Base
  belongs_to :sender,    class_name: 'User', foreign_key: 'sender_id'
  belongs_to :recepient, class_name: 'User', foreign_key: 'recepient_id'

  belongs_to :entry

  # 必須属性の検証
  validates :body,         presence: true
  validates :sender_id,    presence: true
  validates :recepient_id, presence: true

  scope :with, lambda { |user|
    where(
      'sender_id = :user_id or recepient_id = :user_id',
      user_id: user.id
    )
  }

  scope :between, lambda { |user1, user2|
    query = 'sender_id = :user1_id and recepient_id = :user2_id'
    query += ' or recepient_id = :user1_id and sender_id = :user2_id'
    where(
      query,
      user1_id: user1.id,
      user2_id: user2.id
    )
  }
end
