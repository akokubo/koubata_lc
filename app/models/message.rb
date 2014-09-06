class Message < ActiveRecord::Base
  has_many :passings, dependent: :destroy

  attr_accessor :sender_id
  attr_accessor :recepient_id

  # 必須属性の検証
  validates :subject,      presence: true
  validates :body,         presence: true
  validates :sender_id,    presence: true
  validates :recepient_id, presence: true

  def save
    ActiveRecord::Base.transaction do
      super

      self.passings.create(
        user_id:      sender_id,
        companion_id: recepient_id,
        direction:    "outgoing"
      )

      self.passings.create(
        user_id:      recepient_id,
        companion_id: sender_id,
        direction:    "incoming"
      )
    end
  end

end
