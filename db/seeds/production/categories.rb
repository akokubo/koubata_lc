names = [
  'デザイン・工芸',
  '衣類・アパレル',
  '飲べもの',
  '園芸・農業',
  '介護・看護・保育・援助',
  '業務サービス',
  '交流',
  '個人向けサービス',
  '娯楽・レクリエーション',
  'コンピュータ・情報技術',
  '自動車',
  '住宅サービス',
  '宿泊・賃貸住宅',
  '商品',
  '助言・指導・勉強',
  '書籍・出版',
  'からだ・こころ',
  '地域活動',
  '賃貸・レンタル',
  '動物・ペット',
  '配送',
  '勤務・アルバイト',
  'その他'
]

names.each do |name|
  Category.create(
    name: name
  )
end
