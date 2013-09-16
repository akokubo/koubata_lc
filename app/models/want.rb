class Want < ActiveRecord::Base
  belongs_to :user

  # 必須属性の検証
  validates :user_id, presence: true
  validates :title, presence: true
end
