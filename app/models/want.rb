class Want < Task
  has_many :entrusts, foreign_key: 'task_id'#, dependent: :destroy
end
