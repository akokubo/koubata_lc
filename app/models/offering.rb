class Offering < ActiveRecord::Base
  belongs_to :user
  belongs_to :category

  # 必須属性の検証
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true
  validates :price, presence: true
end
