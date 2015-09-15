class Entry < ActiveRecord::Base
  belongs_to :category
  belongs_to :owner, class_name: 'User'
  belongs_to :contractor, class_name: 'User'
  belongs_to :payment

  has_many :negotiations

  # 必須属性の検証
  validates :category_id, presence: true
  validates :owner_id, presence: true
  validates :contractor_id, presence: true
  validates :title, presence: true
  validates :prior_price_description, presence: true
  validates :expected_at, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def task=(task)
    self.category = task.category
    self.title = task.title
    self.description = task.description
    self.prior_price_description = task.price_description
    if task.type == 'Offering'
      self.contractor = task.user
    elsif task.type == 'Want'
      self.owner = task.user
    end
    self
  end

  def owner?(user)
    owner == user
  end

  def contractor?(user)
    contractor == user
  end

  def performer?(user)
    contractor == user
  end

  def payer?(user)
    owner == user
  end

  def payee
    contractor
  end

  def partner_of(subject_user)
    if contractor == subject_user
      owner
    elsif owner == subject_user
      contractor
    end
  end

  def commitable?(user)
    !canceled? && !committed? && (owner?(user) || contractor?(user))
  end

  def performable?(user)
    status == 'to be performed' && performer?(user)
  end

  def payable?(user)
    status == 'to be paid' && payer?(user)
  end

  def cancelable?(user)
    !canceled? && !performed? && (owner?(user) || contractor?(user))
  end

  def status
    if paid?
      'finished'
    elsif performed?
      'to be paid'
    elsif owner_canceled?
      'owner canceled'
    elsif contractor_canceled?
      'contractor canceled'
    elsif committed?
      'to be performed'
    elsif owner_committed?
      'owner committed'
    elsif contractor_committed?
      'contractor committed'
    else
      'to be committed'
    end
  end

  def conditions_change?(args = {})
    expected_at != args[:expected_at] || price != args[:price].to_i
  end

  def url
    Rails.application.routes.url_helpers.entry_path(self)
  end

  private

  # 契約済
  def committed?
    owner_committed? && contractor_committed?
  end

  # オーナーが契約した
  def owner_committed?
    owner_committed_at.present?
  end

  # ユーザーが契約した
  def contractor_committed?
    contractor_committed_at.present?
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
    owner_canceled? || contractor_canceled?
  end

  # オーナーがキャンセル済
  def owner_canceled?
    owner_canceled_at.present?
  end

  # ユーザーがキャンセル済
  def contractor_canceled?
    contractor_canceled_at.present?
  end
end
