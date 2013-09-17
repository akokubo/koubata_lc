class Payment < ActiveRecord::Base
  before_create :account_transfer

  belongs_to :from, class_name: "Account"
  belongs_to :to, class_name: "Account"

  # 必須属性の検証
  validates :from_id, presence: true
  validates :to_id, presence: true
  validates :subject, presence: true
  validates :amount, presence: true

  # 金額は、0以上の整数
  validates :amount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  private
    # 振込の実行
    def account_transfer
      Account.transfer(self.from, self.to, self.amount)
    end
end
