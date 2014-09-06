class Passing < ActiveRecord::Base
  belongs_to :message
  belongs_to :user
  belongs_to :companion,
             class_name: 'User',
             foreign_key: 'companion_id'

  validates :message_id,   presence: true
  validates :user_id,      presence: true
  validates :companion_id, presence: true
  validate  :user_not_equal_companion

  private
    def user_not_equal_companion
      errors.add(:companion_id, :invalid) if user.id == companion.id
    end
end
