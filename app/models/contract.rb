class Contract < Entry
=begin
  def offering
    task
  end

  def offering=(object)
    task_id = object.id
  end

  def offering_id
    task_id
  end

  def offering_id=(object_id)
    task_id = object_id
  end
=end
end
