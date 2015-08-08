names = %w(sakai kasiwaya kushibiki kokubo tsasaki kuji t-sachiko ksuga tsunoda wajima haship kurebayashi)
japanese_names = %w(坂井雄介 柏谷至 櫛引素夫 小久保温 佐々木てる 久慈きみ代 田中志子 菅勝彦 角田均 和島茂 橋本恭能 紅林亘)

0.upto(names.length - 1) do |idx|
  user = User.create(
    name: japanese_names[idx],
    email: "#{names[idx]}@aomori-u.ac.jp",
    password: 'password',
    password_confirmation: 'password',
    confirmed_at: Time.now
  )
  Account.create(
    user_id: user.id,
    balance: 1000
  )
end

user = User.create(
  name: '石橋修',
  email: 'ishibashi@hachinohe-u.ac.jp',
  password: 'password',
  password_confirmation: 'password',
  confirmed_at: Time.now
)
Account.create(
  user_id: user.id,
  balance: 1000
)

user = User.find_by(name: '小久保温')
user.admin = true
user.save
