class Account < ActiveRecord::Base
  belongs_to :user
  has_many :payments, foreign_key: "from_id", dependent: :destroy

  # 必須属性の検証
  validates :user_id, presence: true
  validates :balance, presence: true
  # 残高は整数
  validates :balance, numericality: { only_integer: true }

  validate :balance_must_be_positive

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
    def balance_must_be_positive
      errors.add(:balance, "が負になりました。") if balance < 0
    end

    # 残高を変更して保存
    def adjust_balance_and_save(amount)
      self.balance += amount
      save!
    end
end
