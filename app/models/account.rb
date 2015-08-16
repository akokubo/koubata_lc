class Account < ActiveRecord::Base
  belongs_to :user
  # has_many :payments

  has_many :withdraws, class_name: 'Payment', foreign_key: 'sender_id',    dependent: :destroy
  has_many :deposits,  class_name: 'Payment', foreign_key: 'recepient_id', dependent: :destroy
  has_many :sender,    through: :deposits,  source: :user
  has_many :recepient, through: :withdraws, source: :recepient

  # 必須属性の検証
  validates :user_id, presence: true
  validates :balance, presence: true,
                      numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  class << self
    # 取引の実行
    def transfer(args = {})
      # sender, recepient, amountの存在チェック
      fail 'invalid argument sender'    unless args.key?(:sender) && args[:sender].present?
      fail 'invalid argument recepient' unless args.key?(:recepient) && args[:recepient].present?
      fail 'invalid argument amount'    unless args.key?(:amount) && args[:amount].present?

      # 変数の用意
      sender    = args[:sender]
      recepient = args[:recepient]
      amount    = args[:amount]
      subject  = args[:subject]
      comment  = args[:comment]
      sender_account    = sender.account
      recepient_account = recepient.account

      transaction do
        # ロックを実行　
        sender_account.lock!
        recepient_account.lock!

        # 取引前の残高を取得
        sender_balance_before    = sender_account.balance
        recepient_balance_before = recepient_account.balance

        # 残高の変更
        sender_account.balance -= amount
        recepient_account.balance += amount

        # 残高を記録
        sender_account.save!
        recepient_account.save!

        # 取引前の残高を保持
        sender_balance_after    = sender_account.balance
        recepient_balance_after = recepient_account.balance

        # 取引履歴を記録
        payment = Payment.create!(
          sender:    sender,
          recepient: recepient,
          amount:    amount,
          subject:   subject,
          comment:   comment,
          sender_balance_before:    sender_balance_before,
          recepient_balance_before: recepient_balance_before,
          sender_balance_after:     sender_balance_after,
          recepient_balance_after:  recepient_balance_after
        )

        send_notification(recepient: recepient, sender: sender, amount: amount, payment: payment)

        payment
      end
    end

    private

    def send_notification(args = {})
      # 通知の作成
      Notification.create!(
        user: args[:recepient],
        body: "#{args[:sender].name}さんが、#{args[:amount]}幸を振り込みました。",
        url:  "/payments/#{args[:payment].id}"
      )
    end
  end
end
