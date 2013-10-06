num = User.count
words = %w(おはよう こんにちは こんばんは やあ ごきげんよう さようなら はじめまして お元気ですか よろしくお願いいたします)

100.times do
Message.create(
  {
    from_id: Random.rand(num) + 1,
    to_id: Random.rand(num) + 1,
    subject: words[Random.rand(words.count)],
    body: words[Random.rand(words.count)] * (Random.rand(10) + 5)
  }
)
end
