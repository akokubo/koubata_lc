class Category < ActiveRecord::Base
  # name属性が存在し、唯一であることを検証
  validates :name, presence: true, uniqueness: true

  has_many :offerings
  has_many :wants
end
