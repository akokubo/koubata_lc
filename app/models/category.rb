class Category < ActiveRecord::Base
  # name属性が存在し、唯一であることを検証
  validates :name, presence: true, uniqueness: true

end
