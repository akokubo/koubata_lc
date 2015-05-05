class Category < ActiveRecord::Base
  has_many :tasks
  has_many :offerings
  has_many :wants

  # name属性が存在し、唯一であることを検証
  validates :name, presence: true, uniqueness: true
end
