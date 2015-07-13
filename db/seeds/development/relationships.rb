num = User.count

80.times do
  followed_id = Random.rand(num) + 1
  follower_id = Random.rand(num) + 1
  if followed_id != follower_id
    relationship = Relationship.find_by(followed_id: followed_id, follower_id: follower_id)
    if !relationship
      Relationship.create(
        follower_id: follower_id,
        followed_id: followed_id
      )
    end
  end
end
