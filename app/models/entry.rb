class Entry < ActiveRecord::Base
  before_validation :set_entry_type
  #before_update :check_contract

  belongs_to :task
  belongs_to :offering
  belongs_to :want

  belongs_to :user

  has_many :negotiations

  # 必須属性の検証
  validates :task_id, presence: true
  validates :user_id, presence: true
  validates :price, presence: true, numericality: { only_integer: true, greater_than: 0 }

  # 契約済
  def committed?
    owner_committed? && user_committed?
  end

  def owner_committed?
    !owner_committed_at.blank?
  end

  def user_committed?
    !user_committed_at.blank?
  end

  # 履行済
  def performed?
    !performed_at.blank?
  end

  # 支払済
  def paid?
    !paid_at.blank?
  end

  def canceled?
    owner_canceled? || user_canceled?
  end

  # キャンセル済
  def owner_canceled?
    !owner_canceled_at.blank?
  end

  def user_canceled?
    !user_canceled_at.blank?
  end

  def status
    if paid?
      "paid"
    elsif performed?
      "performed"
=begin
    elsif owner_canceled?
      "owner canceld"
    elsif user_canceled?
      "user canceled"
    elsif committed?
      "committed"
    elsif owner_committed?
      "owner committed"
    elsif user_committed?
      "user_committed"
    else
      "to be committed"
=end
    else
      "committed"
    end
  end

  def owner
    task.user
  end

  def partner_of(target_user)
    if user == target_user
      task.user
    elsif owner == target_user
      user
    else
      nil
    end
  end

  private

    def set_entry_type
      self.type = self.task.type == "Offering" ? "Contract" : "Entrust"
    end

    def check_commit
      old_entry = Entry.find(id)
      if self.expected_at != old_entry.expected_at
        if !self.user_committed_at.blank?
          self.user_committed_at = nil
        else
          self.owner_committed_at = nil
        end
      end
    end
end
