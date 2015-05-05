num = User.count
category_num = Category.count
words = %w(パソコン 料理 買い物 送迎 園芸 家庭教師 大工 店番 話し相手 犬の散歩 ベビーシッター ペンキ塗り 清掃 介護 留守番)
prices = %w(1000ポイント 100ポイント 5ポイント 時給1000ポイント 日給10000ポイント 200ポイント 無料 300ポイント 400ポイント 500ポイント 600ポイント 700ポイント)

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
