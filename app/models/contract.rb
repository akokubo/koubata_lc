class Contract < Entry
  belongs_to :offering, foreign_key: 'task_id'
end
