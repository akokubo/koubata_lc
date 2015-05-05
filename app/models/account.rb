class Account < ActiveRecord::Base
  belongs_to :user
  has_many :payments, foreign_key: 'from_id', dependent: :destroy

  # 必須属性の検証
  validates :user_id, presence: true
  validates :balance, presence: true,
                      numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # 支出
  def withdraw(amount)
    adjust_balance_and_save(-amount)
  end

  # 収入
  def deposit(amount)
    adjust_balance_and_save(amount)
  end

  # 支払い
  def self.transfer(from, to, amount)
    Account.transaction do
      from.withdraw(amount)
      to.deposit(amount)
    end
  end

  private

  # 残高を変更して保存
  def adjust_balance_and_save(amount)
    self.balance += amount
    save!
  end
end
