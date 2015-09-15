user_ids = User.pluck(:id)

80.times do
  followed_id = user_ids.sample
  follower_id = user_ids.sample
  if followed_id != follower_id
    relationship = Relationship.find_by(followed_id: followed_id, follower_id: follower_id)
    unless relationship
      Relationship.create(
        follower_id: follower_id,
        followed_id: followed_id
      )
    end
  end
end
