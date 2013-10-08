class Payment < ActiveRecord::Base
  before_create :account_transfer

  belongs_to :from, class_name: "Account"
  belongs_to :to, class_name: "Account"

  # 必須属性の検証
  validates :from_id, presence: true
  validates :to_id, presence: true
  validates :subject, presence: true
  validates :amount, presence: true
  validates :balance, presence: true

  # 金額は、0以上の整数
  validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :from_id_not_equal_to_id
  validate :balance_must_be_positive

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

  def payment
    if self.direction == "from"
      - self.amount
    else
      self.amount
    end
  end

  def self.list(user_id)
    payments = self.where("from_id = '#{user_id}' or to_id = '#{user_id}'")
    payments.each do |payment|
      if payment.from_id == user_id
        payment.with = User.find(payment.to_id)
        payment.direction = "from"
      else
        payment.with = User.find(payment.from_id)
        payment.direction = "to"
      end
    end
    payments
  end

  def self.withs(user_id)
    with_ids = Array.new
    payments = self.where("from_id = '#{user_id}' or to_id = '#{user_id}'")
    payments.each do |payment|
      if payment.from_id == user_id
        with_ids << payment.to_id
      else
        with_ids << payment.from_id
      end
    end  
    with_ids.uniq
    withs = User.find(with_ids)    
  end

  def self.with(user_id, with_id)
    payments = self.where("(from_id = '#{user_id}' and to_id = '#{with_id}') or (to_id = '#{user_id}' and from_id = '#{with_id}')")
    payments.each do |payment|
      if payment.from_id == user_id
        payment.with = User.find(payment.to_id)
        payment.direction = "from"
      else
        payment.with = User.find(payment.from_id)
        payment.direction = "to"
      end
    end
    payments 
  end

  private
    # 振込の実行
    def account_transfer
      Account.transfer(self.from, self.to, self.amount)
    end

    def balance_must_be_positive
      errors.add(:amount, :invalid) if User.find(self.from_id).account.balance < self.amount
    end

    def from_id_not_equal_to_id
      errors.add(:to_id, :invalid) if from_id == to_id
    end

end
