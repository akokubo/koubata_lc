class Payment < ActiveRecord::Base
  before_create :account_transfer

  belongs_to :from, class_name: 'Account'
  belongs_to :to,   class_name: 'Account'

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

  attr_accessor :with, :direction

  def payment
    if direction == 'from'
      -amount
    else
      amount
    end
  end

  def self.find_by_from_id_or_to_id(user_id)
    payments = where('from_id = ? or to_id = ?', user_id, user_id)
    payments.each do |payment|
      if payment.from_id == user_id
        payment.with = payment.to
        payment.direction = 'from'
      else
        payment.with = payment.from
        payment.direction = 'to'
      end
    end
    payments
  end

=begin
  def self.list(user_id)
    payments = where('from_id = ? or to_id = ?', user_id, user_id)
    payments.each do |payment|
      if payment.from_id == user_id
        payment.with = payment.to
        payment.direction = 'from'
      else
        payment.with = payment.from
        payment.direction = 'to'
      end
    end
    payments
  end

  def self.withs(user_id)
    with_ids = []
    payments = where('from_id = ? or to_id = ?', user_id, user_id)
    payments.each do |payment|
      if payment.from_id == user_id
        with_ids << payment.to_id
      else
        with_ids << payment.from_id
      end
    end
    with_ids.uniq
    withs = User.find(with_ids)
    withs
  end

  def self.with(user_id, with_id)
    payments = where('(from_id = ? and to_id = ?) or (to_id = ? and from_id = ?)',
                     user_id, with_id, user_id, with_id)
    payments.each do |payment|
      if payment.from_id == user_id
        payment.with = payment.to
        payment.direction = 'from'
      else
        payment.with = payment.from
        payment.direction = 'to'
      end
    end
    payments
  end
=end

  private

  # 振込の実行
  def account_transfer
    Account.transfer(from, to, amount)
  end

  def from_id_not_equal_to_id
    errors.add(:to_id, :invalid) if from_id == to_id
  end
end
