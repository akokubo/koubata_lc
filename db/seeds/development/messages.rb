num = User.count
words = %w(おはよう こんにちは こんばんは やあ ごきげんよう さようなら はじめまして お元気ですか よろしくお願いいたします)

100.times do
  sender_id = Random.rand(num) + 1
  recepient_id = Random.rand(num) + 1
  if sender_id != recepient_id
    Message.create(
      sender_id: sender_id,
      recepient_id: recepient_id,
      subject: words[Random.rand(words.count)],
      body: words[Random.rand(words.count)] * (Random.rand(10) + 5)
    )
  end
end
