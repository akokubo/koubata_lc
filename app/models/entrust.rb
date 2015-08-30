class Entrust < Entry
  belongs_to :want, foreign_key: 'task_id'
end
