class Offering < Task
  has_many :contracts, foreign_key: 'task_id'#, dependent: :destroy
end
