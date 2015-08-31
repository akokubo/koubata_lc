FactoryGirl.define do
  # ユーザーの生成
  factory :user do
    sequence(:name) { |n| "person_#{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password 'foobarfoobar'
    password_confirmation 'foobarfoobar'
    confirmed_at Time.now
  end

  factory :account do
    user
    balance 1000
  end

  # カテゴリーの生成
  factory :category do
    sequence(:name) { |n| "category_#{n}" }
  end

  # タスク(できること)の生成
  factory :task do
    user
    sequence(:title) { |n| "task_#{n}" }
    sequence(:description) { |n| "Lorem ipsum #{n}" * 5 }
    sequence(:price) { |n| "the current price #{n}" }
    expired_at 1.day.from_now
    category
    type 'Offering'
  end

  # できることの生成
  factory :offering do
    user
    sequence(:title) { |n| "offering_#{n}" }
    sequence(:description) { |n| "Lorem ipsum #{n}" * 5 }
    sequence(:price) { |n| "the current price #{n}" }
    expired_at 1.day.from_now
    category
  end

  # お願いの生成
  factory :want do
    user
    sequence(:title) { |n| "want_#{n}" }
    sequence(:description) { |n| "Lorem ipsum #{n}" * 5 }
    sequence(:price) { |n| "the current price #{n}" }
    expired_at 1.day.from_now
    category
  end

  # エントリー(依頼)の生成
  factory :entry do
    sequence(:title) { |n| "task_#{n}" }
    sequence(:description) { |n| "Lorem ipsum #{n}" * 5 }
    sequence(:prior_price) { |n| "the current price #{n}" }
    expired_at 1.day.from_now
    category
    owner { user }
    contractor { user }
    expected_at 1.day.from_now
    price { [*1..99].sample }
  end
end
