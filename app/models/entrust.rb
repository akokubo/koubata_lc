class Entrust < Entry
  def want
    self.task
  end

  def want=(object)
    self.task = object
  end

  def want_id
    self.task_id
  end

  def want_id=(object_id)
    self.task_id = object_id
  end
end
