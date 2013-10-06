class Want < ActiveRecord::Base
  before_validation :clear_expired_at

  belongs_to :user

  # 必須属性の検証
  validates :user_id, presence: true
  validates :title, presence: true

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
