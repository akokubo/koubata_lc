num = User.count
words = %w(パソコン 料理 買い物 送迎 園芸 家庭教師 大工 店番 話し相手 犬の散歩 ベビーシッター ペンキ塗り 清掃 介護 留守番)

50.times do
Want.create(
  {
    user_id: Random.rand(num) + 1,
    title: words[Random.rand(words.count)],
    description: words[Random.rand(words.count)] * (Random.rand(10) + 5),
    no_expiration: true
  }
)
end

50.times do
Want.create(
  {
    user_id: Random.rand(num) + 1,
    title: words[Random.rand(words.count)],
    description: words[Random.rand(words.count)] * (Random.rand(10) + 5),
    expired_at: Time.now.days_since(Random.rand(30))
  }
)
end
