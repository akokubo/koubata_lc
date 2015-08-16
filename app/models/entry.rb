class Entry < ActiveRecord::Base
  before_validation :set_entry_type

  belongs_to :task
  belongs_to :offering
  belongs_to :want

  belongs_to :user

  has_many :negotiations

  belongs_to :payment

  # 必須属性の検証
  validates :task_id, presence: true
  validates :user_id, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :expected_at, presence: true

  def owner
    task.user
  end

  def owner?(user)
    task.user == user
  end

  def user?(user)
    self.user == user
  end

  def performer?(user)
    (type == 'Contract' && owner == user) || (type == 'Entrust' && self.user == user)
  end

  def payer?(user)
    (type == 'Contract' && self.user == user) || (type == 'Entrust' && owner == user)
  end

  def payee
    if type == 'Contract'
      owner
    elsif type == 'Entrust'
      user
    end
  end

  def partner_of(subject_user)
    if user == subject_user
      task.user
    elsif owner == subject_user
      user
    end
  end

  def commitable?
    !canceled? && !committed?
  end

  def performable?
    status == 'to be performed'
  end

  def payable?
    status == 'to be paid'
  end

  def cancelable?
    !canceled? && !performed?
  end

  def status
    if paid?
      'closed'
    elsif performed?
      'to be paid'
    elsif owner_canceled?
      'owner canceled'
    elsif user_canceled?
      'user canceled'
    elsif committed?
      'to be performed'
    elsif owner_committed?
      'owner committed'
    elsif user_committed?
      'user committed'
    else
      'to be committed'
    end
  end

  def conditions_change?(args = {})
    expected_at != args[:expected_at] || price != args[:price]
  end

  private

  # 契約済
  def committed?
    owner_committed? && user_committed?
  end

  # オーナーが契約した
  def owner_committed?
    owner_committed_at.present?
  end

  # ユーザーが契約した
  def user_committed?
    user_committed_at.present?
  end

  # 履行済
  def performed?
    performed_at.present?
  end

  # 支払済
  def paid?
    paid_at.present?
  end

  # キャンセル済
  def canceled?
    owner_canceled? || user_canceled?
  end

  # オーナーがキャンセル済
  def owner_canceled?
    owner_canceled_at.present?
  end

  # ユーザーがキャンセル済
  def user_canceled?
    user_canceled_at.present?
  end

  def set_entry_type
    if task.present?
      if task.type == 'Offering'
        self.type = 'Contract'
      elsif task.type == 'Want'
        self.type = 'Entrust'
      end
    end
  end
end
