class Task < ActiveRecord::Base
  belongs_to :category
  belongs_to :user

  scope :readable, lambda {
    where('opened = ?', true)
  }

  # 必須属性の検証
  validates :category_id, presence: true
  validates :user_id, presence: true
  validates :title, presence: true
  validates :price_description, presence: true
  validates :opened, inclusion: { in: [true, false] }
end
