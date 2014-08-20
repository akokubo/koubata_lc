names = %w(kokubo sakai kasiwaya kusibiki tsasaki kuji t-sachiko ksuga)
japanese_names = %w(小久保温 坂井雄介 柏谷至 櫛引素夫 佐々木てる 久慈きみ代 田中志子 菅勝彦)

0.upto(names.length - 1) do |idx|
  user = User.create(
    name: japanese_names[idx],
    email: "#{names[idx]}@aomori-u.ac.jp",
    password: "password",
    password_confirmation: "password",
    confirmed_at: Time.now
  )
  Account.create(
    user_id: user.id,
    balance: 1000
  )
end

user = User.create(
  name: "石橋修",
  email: "ishibashi@hachinohe-u.ac.jp",
  password: "password",
  password_confirmation: "password",
  confirmed_at: Time.now
)
Account.create(
  user_id: user.id,
  balance: 1000
)
