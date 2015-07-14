class Contract < Entry
  def offering
    self.task
  end

  def offering=(object)
    self.task = object
    self.task_id = object.id
  end

  def offering_id
    self.task_id
  end

  def offering_id=(object_id)
    self.task_id = object_id
  end
end
