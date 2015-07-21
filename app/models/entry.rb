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

  # 契約済
  def contracted?
    owner_contracted? && user_contracted?
  end

  def owner_contracted?
    !owner_contracted_at.blank?
  end

  def user_contracted?
    !user_contracted_at.blank?
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
    elsif contracted?
      "contracted"
    elsif owner_contracted?
      "owner contracted"
    elsif user_contracted?
      "user_contracted"
    else
      "to be contracted"
=end
    else
      "contracted"
    end
  end

  private

    def set_entry_type
      self.type = self.task.type == "Offering" ? "Contract" : "Entrust"
    end

    def check_contract
      old_entry = Entry.find(id)
      if self.expected_at != old_entry.expected_at
        if !self.user_contracted_at.blank?
          self.user_contracted_at = nil
        else
          self.owner_contracted_at = nil
        end
      end
    end
end
