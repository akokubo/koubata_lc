FactoryGirl.define do
  # ユーザーの生成
  factory :user do
    sequence(:name) { |n| "person_#{n}" }
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
    sequence(:title) { |n| "offering_#{n}"}
    sequence(:description) { |n| "Lorem ipsum #{n}" * 5 }
    sequence(:price) { |n| "the current price #{n}"}
    expired_at 1.day.from_now
    category
  end

  # お願いの生成
  factory :want do
    user
    sequence(:title) { |n| "want_#{n}"}
    sequence(:description) { |n| "Lorem ipsum #{n}" * 5 }
    expired_at 1.day.from_now
  end
end