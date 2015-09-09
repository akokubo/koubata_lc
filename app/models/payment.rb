class Payment < ActiveRecord::Base
  before_validation :set_subject
  belongs_to :sender_account, class_name: 'Account', foreign_key: 'sender_account_id'
  belongs_to :recepient_account, class_name: 'Account', foreign_key: 'recepient_account_id'
  has_one :entry

  # 必須属性の検証
  validates :sender_account_id,    presence: true
  validates :recepient_account_id, presence: true
  validates :subject, presence: true

  # 金額は、0以上の整数
  validates :amount,                   presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :sender_balance_before,    presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :sender_balance_after,     presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :recepient_balance_before, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :recepient_balance_after,  presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :sender_account_id_not_equal_recepient_account_id
  validate :sender_balance_after_validity
  validate :recepient_balance_after_validity

  def partner_of(user_account)
    if sender_account == account
      recepient_account
    elsif recepient_account == account
      sender_account
    end
  end

  def type_for(account)
    if sender_account == account
      'withdraw'
    elsif recepient_account == account
      'deposit'
    end
  end

  def balance_before_for(account)
    if sender_account == account
      sender_balance_before
    elsif recepient_account == account
      recepient_balance_before
    end
  end

  def balance_after_for(account)
    if sender_account == account
      sender_balance_after
    elsif recepient_account == account
      recepient_balance_after
    end
  end

  def amount_for(account)
    if sender_account == account
      -amount
    elsif recepient_account == account
      amount
    end
  end

  private

  def set_subject
    self.subject = '無題' unless subject.present?
  end

  def sender_account_id_not_equal_recepient_account_id
    errors.add(:recepient_account_id, :invalid) if sender_account_id == recepient_account_id
  end

  def sender_balance_after_validity
    if amount.is_a?(Integer)
      unless sender_balance_after == (sender_balance_before - amount)
        errors.add(:sender_balance_after, :invalid)
      end
    end
  end

  def recepient_balance_after_validity
    if amount.is_a?(Integer)
      unless recepient_balance_after == (recepient_balance_before + amount)
        errors.add(:recepient_balance_after, :invalid)
      end
    end
  end
end
