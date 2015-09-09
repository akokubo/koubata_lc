user_ids = User.pluck(:id)
category_ids = Category.pluck(:id)

words = %w(パソコン 料理 買い物 送迎 園芸 家庭教師 大工 店番 話し相手 犬の散歩 ベビーシッター ペンキ塗り 清掃 介護 留守番)
prices = %w(1000幸 100幸 5幸 時給1000幸 日給10000幸 200幸 無料 300幸 400幸 500幸 600幸 700幸)

100.times do
  Want.create(
    category_id: category_ids.sample,
    user_id: user_ids.sample,
    title: words[Random.rand(words.count)],
    description: words[Random.rand(words.count)] * (Random.rand(10) + 5),
    price_description: prices[Random.rand(prices.count)]
  )
end
