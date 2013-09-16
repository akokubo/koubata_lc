FactoryGirl.define do
  # ユーザーの生成
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobarfoobar"
    password_confirmation "foobarfoobar"
  end
end