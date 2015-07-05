class Entry < ActiveRecord::Base
#  before_validation :clear_hired_at

  belongs_to :task
  belongs_to :user

  # 必須属性の検証
  validates :task_id, presence: true
  validates :user_id, presence: true

  def hired?
    !hired_at.blank?
  end

=begin
  def hired=(val)
    @hired = val.in?([true, 1, '1'])
  end

  private

    def clear_hired_at
      self.hired_at = nil if @hired
    end
=end
end
