class Account < ActiveRecord::Base
  belongs_to :user
  has_many :payments

  # 必須属性の検証
  validates :user_id, presence: true
  validates :balance, presence: true,
                      numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # 支出
  def withdraw(amount)
    adjust_balance_and_save(amount)
  end

  # 収入
  def deposit(amount)
    adjust_balance_and_save(-amount)
  end

  # 支払い
  def self.transfer(from, to, amount, subject, comment)
    Account.transaction do
      from.deposit(amount)
      to.withdraw(amount)
      Payment.create(
        user_id:    from.id,
        partner_id: to.id,
        amount:     -amount,
        subject:    subject,
        comment:    comment,
        direction:  'deposit' # 支払
      )
      Payment.create(
        user_id:    to.id,
        partner_id: from.id,
        amount:     amount,
        subject:    subject,
        comment:    comment,
        direction:  'withdraw' # 振込
      )
    end
  end

  private

  # 残高を変更して保存
  def adjust_balance_and_save(amount)
    self.balance += amount
    save!
  end
end
