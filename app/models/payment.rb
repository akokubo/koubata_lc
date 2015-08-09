class Payment < ActiveRecord::Base
  before_validation :set_balance

  belongs_to :user,    class_name: 'User'
  belongs_to :partner, class_name: 'User'

  # 必須属性の検証
  validates :user_id, presence: true
  validates :partner_id, presence: true
  validates :subject, presence: true
  validates :amount, presence: true
  validates :balance, presence: true
  validates :direction, presence: true

  # 金額は、0以上の整数
  validates :amount, numericality: { only_integer: true }
  validates :balance, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validate :user_id_not_equal_partner_id
  validate :payment_must_be_positive

  private

  # 残高の設定
  def set_balance
    if user
      self.balance = user.account.balance
    else
      self.balance = 0
    end
  end

  def user_id_not_equal_partner_id
    errors.add(:partner_id, :invalid) if user_id == partner_id
  end

  def payment_must_be_positive
    if !amount || (amount > 0 && direction == 'deposit') || (amount < 0 && direction == 'withdraw')
      errors.add(:amount, :invalid)
    end
  end
end
