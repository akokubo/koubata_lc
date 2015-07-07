num = User.count
category_num = Category.count
words = %w(パソコン 料理 買い物 送迎 園芸 家庭教師 大工 店番 話し相手 犬の散歩 ベビーシッター ペンキ塗り 清掃 介護 留守番)
prices = %w(1000幸 100幸 5幸 時給1000幸 日給10000幸 200幸 無料 300幸 400幸 500幸 600幸 700幸)

100.times do
  Offering.create(
    user_id: Random.rand(num) + 1,
    title: words[Random.rand(words.count)],
    category_id: Random.rand(category_num) + 1,
    description: words[Random.rand(words.count)] * (Random.rand(10) + 5),
    price: prices[Random.rand(prices.count)],
    no_expiration: true
  )
end

100.times do
  Offering.create(
    user_id: Random.rand(num) + 1,
    title: words[Random.rand(words.count)],
    category_id: Random.rand(category_num) + 1,
    description: words[Random.rand(words.count)] * (Random.rand(10) + 5),
    price: prices[Random.rand(prices.count)],
    expired_at: Time.now.days_since(Random.rand(30))
  )
end
