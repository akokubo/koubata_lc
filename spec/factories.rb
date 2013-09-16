FactoryGirl.define do
  # ユーザーの生成
  factory :user do
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobarfoobar"
    password_confirmation "foobarfoobar"
  end

  # カテゴリーの生成
  factory :category do
    sequence(:name) { |n| "category_#{n}" }
  end

  # できることの生成
  factory :offering do
    user
    title "Lorem ipsum"
    description "Lorem ipsum" * 5
    price "the current price"
    expired_at 1.day.from_now
    category
  end
end