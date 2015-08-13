user_ids = User.pluck(:id)
words = %w(おはよう こんにちは こんばんは やあ ごきげんよう さようなら はじめまして お元気ですか よろしくお願いいたします)

1000.times do
  sender_id = user_ids.sample
  recepient_id = user_ids.sample
  if sender_id != recepient_id
    Talk.create(
      sender: User.find(sender_id),
      recepient: User.find(recepient_id),
      body: words[Random.rand(words.count)] * (Random.rand(10) + 5)
    )
  end
end
