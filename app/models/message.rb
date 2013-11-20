class Message < ActiveRecord::Base
  belongs_to :from, class_name: "User"
  belongs_to :to, class_name: "User"

  # 必須属性の検証
  validates :from_id, presence: true
  validates :to_id, presence: true
  validates :subject, presence: true
  validates :body, presence: true

  validate :from_id_not_equal_to_id

  def with
    @with
  end

  def with=(value)
    @with = value
  end

  def direction
    @direction
  end

  def direction=(value)
    @direction = value
  end

  def self.list(user_id)
    messages = self.where("from_id = '#{user_id}' or to_id = '#{user_id}'")
    messages.each do |message|
      if message.from_id == user_id
        message.with = message.to
        message.direction = "from"
      else
        message.with = message.from
        message.direction = "to"
      end
    end
    messages
  end

  def self.withs(user_id)
    with_ids = Array.new
    messages = self.where("from_id = '#{user_id}' or to_id = '#{user_id}'")
    messages.each do |message|
      if message.from_id == user_id
        with_ids << message.to_id
      else
        with_ids << message.from_id
      end
    end  
    with_ids.uniq
    withs = User.find(with_ids)    
  end

  def self.with(user_id, with_id)
    messages = self.where("(from_id = '#{user_id}' and to_id = '#{with_id}') or (to_id = '#{user_id}' and from_id = '#{with_id}')").order("created_at DESC")
    messages.each do |message|
      if message.from_id == user_id
        message.with = message.to
        message.direction = "from"
      else
        message.with = message.from
        message.direction = "to"
      end
    end
    messages 
  end

  private
    def from_id_not_equal_to_id
      errors.add(:to_id, :invalid) if from_id == to_id
    end
end
