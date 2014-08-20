class Task < ActiveRecord::Base
  before_validation :clear_expired_at

  belongs_to :user
  belongs_to :category

  scope :readable, -> {
    now = Time.current
    where("? < expired_at OR expired_at IS NULL", now)
  }

  # 必須属性の検証
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true
  validates :price, presence: true

  def no_expiration
    expired_at.blank?
  end

  def no_expiration=(val)
    @no_expiration = val.in?([true, 1, "1"])
  end

  private

    def clear_expired_at
      self.expired_at = nil if @no_expiration
    end
end
