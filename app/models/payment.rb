class Payment < ActiveRecord::Base
  before_validation :set_subject
  belongs_to :sender,     class_name: 'User'
  belongs_to :recepient,  class_name: 'User'

  # 必須属性の検証
  validates :sender_id,    presence: true
  validates :recepient_id, presence: true
  validates :subject, presence: true

  # 金額は、0以上の整数
  validates :amount,                   presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :sender_balance_before,    presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :sender_balance_after,     presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :recepient_balance_before, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :recepient_balance_after,  presence: true, numericality: { only_integer: true, greater_than: 0 }

  validate :sender_id_not_equal_recepient_id
  validate :sender_balance_after_validity
  validate :recepient_balance_after_validity

  def partner_of(user)
    if sender == user
      recepient
    elsif recepient == user
      sender
    else
      nil
    end
  end

  def type_for(user)
    if sender == user
      'withdraw'
    elsif recepient == user
      'deposit'
    else
      nil
    end
  end

  def balance_before_for(user)
    if sender == user
      sender_balance_before
    elsif recepient == user
      recepient_balance_before
    else
      nil
    end
  end

  def balance_after_for(user)
    if sender == user
      sender_balance_after
    elsif recepient == user
      recepient_balance_after
    else
      nil
    end
  end

  def amount_for(user)
    if sender == user
      -amount
    elsif recepient == user
      amount
    else
      nil
    end
  end

  private

  def set_subject
    self.subject = '無題' unless subject.present?
  end

  def sender_id_not_equal_recepient_id
    errors.add(:recepient_id, :invalid) if sender_id == recepient_id
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
