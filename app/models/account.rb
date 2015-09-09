class Account < ActiveRecord::Base
  belongs_to :user
  # has_many :payments, dependent: :destroy

  has_many :withdraws,  class_name: 'Payment', foreign_key: 'sender_id',    dependent: :destroy
  has_many :deposits,   class_name: 'Payment', foreign_key: 'recepient_id', dependent: :destroy
=begin
  has_many :senders,    through: :deposits,  source: :user
  has_many :recepients, through: :withdraws, source: :recepient
=end

  # 必須属性の検証
  validates :user_id, presence: true
  validates :balance, presence: true,
                      numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  class << self
    # 取引の実行
    def transfer(args = {})
      # sender, recepient, amountの存在チェック
      fail 'invalid argument sender_account'    unless args.key?(:sender_account) && args[:sender_account].present?
      fail 'invalid argument recepient_account' unless args.key?(:recepient_account) && args[:recepient_account].present?
      fail 'invalid argument amount'            unless args.key?(:amount) && args[:amount].present?

      # 変数の用意
      sender_account    = args[:sender_account]
      recepient_account = args[:recepient_account]
      amount    = args[:amount]
      subject  = args[:subject]
      comment  = args[:comment]

      transaction do
        # ロックを実行　
        sender_account.lock!
        recepient_account.lock!

        # 取引前の残高を取得
        sender_balance_before    = sender_account.balance
        recepient_balance_before = recepient_account.balance

        # 残高の変更
        sender_account.balance    -= amount
        recepient_account.balance += amount

        # 残高を記録
        sender_account.save!
        recepient_account.save!

        # 取引前の残高を保持
        sender_balance_after    = sender_account.balance
        recepient_balance_after = recepient_account.balance

        # 取引履歴を記録
        payment = Payment.create!(
          sender_account:    sender_account,
          recepient_account: recepient_account,
          amount:  amount,
          subject: subject,
          comment: comment,
          sender_balance_before:    sender_balance_before,
          recepient_balance_before: recepient_balance_before,
          sender_balance_after:     sender_balance_after,
          recepient_balance_after:  recepient_balance_after
        )

        send_notification(
          recepient: recepient_account.user,
          sender: sender_account.user,
          amount: amount,
          payment: payment
        )

        payment
      end
    end

    private

    def send_notification(args = {})
      # 通知の作成
      Notification.create!(
        user: args[:recepient],
        body: "#{args[:sender].name}さんが、#{args[:amount]}幸を振り込みました。",
        url: Rails.application.routes.url_helpers.payment_path(args[:payment])
      )
    end
  end
end
